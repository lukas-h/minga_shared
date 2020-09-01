import 'package:firestore_api/firestore_api.dart';
import '../utils/image_service.dart';
import '../utils/location_service.dart';
import 'package:turf/nearest_point.dart';
import 'package:turf/turf.dart';
import 'donation_bloc.dart';
import '../center/center_model.dart';
import '../user/user_model.dart';
import '../discussion/discussion_bloc.dart';
import '../discussion/discussion_service.dart';
import 'donation_model.dart';

class DonationService {
  final Firestore firestore;
  Donation donation;

  DonationService(this.firestore, this.donation);

  get discussion =>
      DiscussionBloc(DiscussionService(firestore, parent: donation.selfRef));

  Future<void> create([Donation newDonation]) {
    donation = newDonation ?? donation;
    donation.selfRef ??= firestore.collection('donations').document();

    return newDonation.selfRef.setData(newDonation.toMap());
  }

  Future<void> assignCenter() async {
    try {
      var snap = await firestore.collection('centers').getDocuments();
      List<DistributionCenter> centers = snap.documents
          .map((docSnap) => DistributionCenter.fromSnapshot(docSnap))
          .toList();

      if (donation.startLocation == null) {
        return; // TODO throw
      }
      var targetPoint = Feature.fromJson(donation.startLocation);
      var nearest = nearestPoint(
        targetPoint,
        FeatureCollection<Point>(
          features:
              centers.map((e) => Feature<Point>.fromJson(e.location)).toList(),
        ),
      );
      var nearestCenter = centers.singleWhere((element) =>
          Feature<Point>.fromJson(element.location).geometry ==
          nearest.geometry);

      var mapboxUrl = PositionService()
          .getDirectionsImage(targetPoint.geometry, nearest.geometry);
      var cloudinaryUrl = await ImageService().uploadfromUrl(mapboxUrl);

      donation
        ..centerRef = nearestCenter.selfRef
        ..centerLabel = nearestCenter.label
        ..centerAdmins = nearestCenter.admins
        ..deliveryMapImage = cloudinaryUrl;

      await donation.selfRef.update(donation.toMap());
    } catch (e) {
      print(e); // TODO throw
    }
  }

  Future<void> needsDeliveryService(bool needsDeliveryService) async {
    donation.needsDeliveryService = needsDeliveryService;

    // TODO create delivery service
  }

  Future<void> deliveryServiceStaffed(
      DocumentReference assignedCollectorRef) async {
    donation.assignedCollectorRef = assignedCollectorRef;
    donation.selfRef.update(donation.toMap());
  }

  Future<void> pickedUp() async {}
  Future<void> delivered() async {}
  Future<void> deliveryVerified() async {}

  Stream<DonationEvent> get events => donation.selfRef.snapshots.map(
        (snap) => DonationEvent.fromDonationChange(
          donation,
          donation = Donation.fromSnapshot(snap),
        ),
      );
}

class DonationListService {
  final Firestore firestore;
  final Query query;
  DonationListService._(this.firestore, this.query);
  factory DonationListService.forDonor(Firestore firestore, MingaUser user) =>
      _DonorDonationListService(firestore, user);

  factory DonationListService.forCenter(
          Firestore firestore, DistributionCenter center) =>
      _CenterDonationListService(firestore, center);

  Stream<List<Donation>> donationStream() => query.snapshots().map(
        (snap) =>
            snap.documents.map((doc) => Donation.fromSnapshot(doc)).toList(),
      );
}

class _DonorDonationListService extends DonationListService {
  _DonorDonationListService(Firestore firestore, MingaUser user)
      : super._(
            firestore,
            firestore
                .collection('donations')
                .where('donorRef', isEqualTo: user.selfRef));
  Future<void> setDonation(Donation donation) =>
      firestore.collection('donations').document().setData(donation.toMap());
}

class _CenterDonationListService extends DonationListService {
  _CenterDonationListService(Firestore firestore, DistributionCenter center)
      : super._(
            firestore,
            firestore
                .collection('donations')
                .where('centerRef', isEqualTo: center.selfRef));
}
