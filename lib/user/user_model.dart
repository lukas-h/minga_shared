import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'user_model.g.dart';

@FirestoreDocument()
class MingaUser {
  DocumentReference selfRef;
  @FirestoreAttribute(ignore: true)
  String get label => firstName + lastName;

  String firstName;
  String lastName;

  String email;

  String phone;

  MingaUser({
    this.selfRef,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory MingaUser.fromSnapshot(DocumentSnapshot snapshot) =>
      _$mingaUserFromSnapshot(snapshot);
  factory MingaUser.fromMap(Map<String, dynamic> data) =>
      _$mingaUserFromMap(data);
  Map<String, dynamic> toMap() => _$mingaUserToMap(this);
}
