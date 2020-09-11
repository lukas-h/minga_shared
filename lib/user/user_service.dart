import 'package:firestore_api/firestore_api.dart';
import '../actions.dart';
import 'user_model.dart';

class CreateUserAction extends DocumentAction<UserModel> {
  CreateUserAction(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(UserModel model) async {
    await addSetDataToBatch(model.selfRef, model.toMap());
    return ActionResult.success(model.selfRef, 'UserModel', ActionType.create);
  }
}

class UpdateUserAction extends DocumentAction<UserModel> {
  final UserModel before;
  UpdateUserAction(Firestore firestore, {this.before}) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(UserModel model) async {
    await addUpdateToBatch(model.selfRef, model.toMap());
    return ActionResult.success(model.selfRef, 'UserModel', ActionType.update);
  }
}

class UserService {
  final Firestore _firestore;

  UserService(this._firestore);

  CollectionReference get collection => _firestore.collection('users');
  Future<bool> exists(UserModel user) async =>
      (await user.selfRef.document).exists;

  Future<void> setData(UserModel user) =>
      user.selfRef.setData(user.toMap(), merge: true);
  Future<void> update(UserModel user) => user.selfRef.update(user.toMap());
  Future<void> delete(UserModel user) => user.selfRef.delete();
  Future<UserModel> getData(UserModel user) async =>
      UserModel.fromSnapshot(await user.selfRef.document);
}
