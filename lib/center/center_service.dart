import 'package:firestore_api/firestore_api.dart';
import '../user/profile_model.dart';
import '../user/profile_role.dart';
import '../actions.dart';
import 'center_model.dart';

class CreateCenterAction extends DocumentAction<CenterModel> {
  CreateCenterAction(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(CenterModel model) {
    // TODO: implement runActionInternal
    throw UnimplementedError();
  }
}

class CreateRoleAction extends DocumentAction<ProfileModel> {
  final CenterModel centerModel;
  CreateRoleAction(Firestore firestore, this.centerModel) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(ProfileModel model) async {
    try {
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
    } catch (e) {
      return ActionResult.failure(
        model.selfRef,
        'CenterModel',
        ActionType.create,
        message: e.toString(),
      );
    }
  }
}
