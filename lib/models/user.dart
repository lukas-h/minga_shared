import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'user.g.dart';

@FirestoreDocument()
class User {
  DocumentReference selfRef;

  @FirestoreAttribute(ignore: true)
  List<String> roles;

  @FirestoreAttribute(ignore: true)
  String get label => firstName + lastName;

  String firstName;
  String lastName;

  String email;

  String phone;

  User({
    this.selfRef,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
  });

  factory User.fromSnapshot(DocumentSnapshot snapshot) =>
      _$userFromSnapshot(snapshot);
  factory User.fromMap(Map<String, dynamic> data) => _$userFromMap(data);
  Map<String, dynamic> toMap() => _$userToMap(this);
}

@FirestoreDocument(hasSelfRef: false)
class UserRole {
  final String label;

  UserRole({this.label});
  factory UserRole.fromSnapshot(DocumentSnapshot snapshot) =>
      _$userRoleFromSnapshot(snapshot);
  factory UserRole.fromMap(Map<String, dynamic> data) =>
      _$userRoleFromMap(data);
  Map<String, dynamic> toMap() => _$userRoleToMap(this);
}
