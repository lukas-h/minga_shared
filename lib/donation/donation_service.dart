import 'package:firestore_api/firestore_api.dart';
import '../utils/compensation.dart';
import '../center/center_service.dart';
import '../user/profile_model.dart';
import '../user/profile_role.dart';
import '../voluntary_work/voluntary_work_model.dart';
import 'package:turf/turf.dart';
import '../actions.dart';
import '../utils/location_service.dart';
import 'package:turf/nearest_point.dart';
import '../center/center_model.dart';
import 'donation_model.dart';

class DonationQuery extends DocumentQuery<DonationModel> {
  DonationQuery(String documentId, Firestore firestore)
      : super(firestore.collection('donations').document(documentId));

  @override
  DonationModel mapQuery(DocumentSnapshot snapshot) =>
      DonationModel.fromSnapshot(snapshot);
}

class DonationsQuery extends CollectionQuery<DonationModel> {
  DonationsQuery.forDonor(ProfileModel profileModel, Firestore firestore)
      : super(
          firestore
              .collection('donations')
              .where('donorRef', isEqualTo: profileModel.selfRef),
        );
  DonationsQuery.forCenter(CenterModel centerModel, Firestore firestore)
      : super(
          firestore
              .collection('donations')
              .where('centerRef', isEqualTo: centerModel.selfRef),
        );
  @override
  List<DonationModel> mapQuery(List<DocumentSnapshot> snapshots) =>
      snapshots.map((docSnap) => DonationModel.fromSnapshot(docSnap)).toList();
}

class DonationUpdatesQuery extends CollectionQuery<DonationUpdateModel> {
  DonationUpdatesQuery(DonationModel donationModel)
      : super(donationModel.selfRef.collection('updates'));

  @override
  List<DonationUpdateModel> mapQuery(List<DocumentSnapshot> snapshots) =>
      snapshots
          .map((docSnap) => DonationUpdateModel.fromSnapshot(docSnap))
          .toList();
}

class DonationRolesQuery extends CollectionQuery<ProfileRoleModel> {
  DonationRolesQuery(DonationModel donationModel)
      : super(donationModel.selfRef.collection('roles'));

  @override
  List<ProfileRoleModel> mapQuery(List<DocumentSnapshot> snapshots) => snapshots
      .map((docSnap) => ProfileRoleModel.fromSnapshot(docSnap))
      .toList();
}

class CreateDonationAction extends DocumentAction<DonationModel> {
  final ProfileModel donor;
  CreateDonationAction(Firestore firestore, this.donor) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(model) async {
    model
      ..selfRef ??= firestore.collection('donations').document()
      ..donorRef ??= donor.selfRef;
    await addSetDataToBatch(model.selfRef, model.toMap());

    var role = ProfileRoleModel(
      selfRef:
          model.selfRef.collection('roles').document(donor.selfRef.documentID),
      profileRef: donor.selfRef,
      label: donor.label,
      type: DonationRoleTypes.donor,
    );
    await addSetDataToBatch(role.selfRef, role.toMap());

    var update = DonationUpdateModel(
      selfRef: model.selfRef.collection('updates').document(),
      created: DateTime.now(),
      type: DonationUpdateType.created,
    );
    await addSetDataToBatch(update.selfRef, update.toMap());

    return ActionResult.success(model.selfRef, 'label', ActionType.create);
  }
}

// triggers cloud function if donation is created
class DonationAssignCenterAction extends DocumentAction<DonationModel> {
  DonationAssignCenterAction(Firestore firestore) : super(firestore);

  Future<CenterModel> _nearestCenter(DonationModel donationModel) async {
    var centers = await CentersQuery(firestore).documents;
    if (centers.isEmpty) {
      return null;
    }
    List<Feature<Point>> centerFeatures =
        centers.where((center) => center.location != null).map((center) {
      var feat = Feature<Point>.fromJson(center.location);
      feat.fields.addAll({'self': center});
      return feat;
    }).toList();
    var collection = FeatureCollection(features: centerFeatures);

    var target = Feature<Point>.fromJson(donationModel.startLocation);

    var resultFeature = nearestPoint(target, collection);
    return resultFeature.fields['self'];
  }

  String _getLocationMapImage(
      Map<String, dynamic> start, Map<String, dynamic> end) {
    var startPoint = Feature<Point>.fromJson(start).geometry;
    var endPoint = Feature<Point>.fromJson(end).geometry;
    return LocationImageService().getDirectionsImage(startPoint, endPoint);
  }

  @override
  Future<ActionResult> runActionInternal(DonationModel model) async {
    var nearestCenter = await _nearestCenter(model);
    if (nearestCenter != null) {
      model
        ..endLocation = nearestCenter.location
        ..deliveryMapImage =
            _getLocationMapImage(model.startLocation, model.endLocation)
        ..centerLabel = nearestCenter.label
        ..centerRef = nearestCenter.selfRef;
      await addUpdateToBatch(model.selfRef, model.toMap());

      var roles = await CenterRolesQuery(nearestCenter.selfRef).documents;

      for (var role in roles) {
        var donationRole = ProfileRoleModel(
          selfRef: model.selfRef
              .collection('roles')
              .document(role.selfRef.documentID),
          label: role.label,
          profileRef: role.profileRef,
          type: DonationRoleTypes.centerAdmin,
        );
        await addSetDataToBatch(donationRole.selfRef, donationRole.toMap());
      }

      var update = DonationUpdateModel(
        selfRef: model.selfRef.collection('updates').document(),
        created: DateTime.now(),
        type: DonationUpdateType.assignedToCenter,
      );
      await addSetDataToBatch(update.selfRef, update.toMap());

      return ActionResult.success(
        model.selfRef,
        'DonationModel',
        ActionType.update,
      );
    } else {
      return ActionResult.failure(
        model.selfRef,
        'DonationModel',
        ActionType.update,
        message: 'could not assign nearest center',
      );
    }
  }
}

class DonationNeedsDeliveryService extends DocumentAction<DonationModel> {
  DonationNeedsDeliveryService(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(DonationModel model) async {
    var update = DonationUpdateModel(
      selfRef: model.selfRef.collection('updates').document(),
      created: DateTime.now(),
      type: DonationUpdateType.needsDelivery,
    );
    await addSetDataToBatch(update.selfRef, update.toMap());

    return ActionResult.success(
      model.selfRef,
      'DonationModel',
      ActionType.update,
    );
  }
}

// triggers cloud function if update needsDelivery is created
class DonationCreateDeliveryService extends DocumentAction<DonationModel> {
  DonationCreateDeliveryService(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(DonationModel model) async {
    _createLabel() => 'deliver ${model.label} to ${model.centerLabel}';

    var deliveryShift = VoluntaryWorkModel(
      selfRef: firestore.collection('voluntaryWork').document(),
      assignedApplication: null,
      assignedProfile: null,
      from: DateTime.now(),
      to: DateTime.now().add(Duration(hours: model.maximumDelayForPickup)),
      type: VoluntaryWorkType.delivery,
      centerRef: model.centerRef,
      created: DateTime.now(),
      impactPoints: CompensationCalculator.calculateDelivery(model),
      label: _createLabel(),
      startLocation: model.startLocation,
      endLocation: model.endLocation,
    );

    await addSetDataToBatch(deliveryShift.selfRef, deliveryShift.toMap());

    var update = DonationUpdateModel(
      selfRef: model.selfRef.collection('updates').document(),
      created: DateTime.now(),
      type: DonationUpdateType.openForApplication,
    );
    await addSetDataToBatch(update.selfRef, update.toMap());

    return ActionResult.success(
      model.selfRef,
      'DonationModel',
      ActionType.update,
    );
  }
}
