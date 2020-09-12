import 'package:firestore_api/firestore_api.dart';
import '../user/profile_model.dart';
import '../user/profile_role.dart';
import '../actions.dart';
import 'center_model.dart';

class CentersQuery extends CollectionQuery<CenterModel> {
  CentersQuery(Firestore firestore) : super(firestore.collection('centers'));

  @override
  List<CenterModel> mapQuery(List<DocumentSnapshot> snapshots) =>
      snapshots.map((docSnap) => CenterModel.fromSnapshot(docSnap)).toList();
}

class CenterRolesQuery extends CollectionQuery<ProfileRoleModel> {
  CenterRolesQuery(DocumentReference centerRef)
      : super(centerRef.collection('roles'));

  @override
  List<ProfileRoleModel> mapQuery(List<DocumentSnapshot> snapshots) => snapshots
      .map((docSnap) => ProfileRoleModel.fromSnapshot(docSnap))
      .toList();
}

class CreateCenterAction extends DocumentAction<CenterModel> {
  final ProfileModel profileModel;
  CreateCenterAction(Firestore firestore, this.profileModel) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(CenterModel model) async {
    model.selfRef ??= firestore.collection('centers').document();
    await addSetDataToBatch(model.selfRef, model.toMap());
    if (profileModel != null) {
      var role = ProfileRoleModel(
        selfRef: model.selfRef
            .collection('roles')
            .document(profileModel.selfRef.documentID),
        label: profileModel.label,
        profileRef: profileModel.selfRef,
      );
      await addSetDataToBatch(role.selfRef, role.toMap());
    }
    return ActionResult.success(
      model.selfRef,
      'CenterModel',
      ActionType.create,
    );
  }
}

class CreateRoleAction extends DocumentAction<ProfileModel> {
  final CenterModel centerModel;
  CreateRoleAction(Firestore firestore, this.centerModel) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(ProfileModel model) async {
    var role = ProfileRoleModel(
      selfRef: centerModel.selfRef
          .collection('roles')
          .document(model.selfRef.documentID),
      label: model.label,
      profileRef: model.selfRef,
    );

    await addSetDataToBatch(role.selfRef, role.toMap());
    return ActionResult.success(
      model.selfRef,
      'CenterModel',
      ActionType.create,
    );
  }
}
