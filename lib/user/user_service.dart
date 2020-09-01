import 'package:firestore_api/firestore_api.dart';
import 'package:minga_shared/user/user_model.dart';

class UserService {
  final Firestore _firestore;

  UserService(this._firestore);

  CollectionReference get collection => _firestore.collection('users');
  Future<bool> exists(MingaUser user) async =>
      (await user.selfRef.document).exists;

  Future<void> setData(MingaUser user) =>
      user.selfRef.setData(user.toMap(), merge: true);
  Future<void> update(MingaUser user) => user.selfRef.update(user.toMap());
  Future<void> delete(MingaUser user) => user.selfRef.delete();
  Future<MingaUser> getData(MingaUser user) async =>
      MingaUser.fromSnapshot(await user.selfRef.document);
}
