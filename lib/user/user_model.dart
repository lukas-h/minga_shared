import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'user_model.g.dart';

@FirestoreDocument()
class MingaUser {
  DocumentReference selfRef;

  @FirestoreAttribute(ignore: true)
  String get label => displayName;

  String displayName;

  String email;

  String phone;

  Map<String, dynamic> location;

  bool anonymizeDonations;

  MingaUser({
    this.selfRef,
    this.displayName,
    this.email,
    this.phone,
    this.location,
    this.anonymizeDonations,
  });

  factory MingaUser.fromSnapshot(DocumentSnapshot snapshot) =>
      _$mingaUserFromSnapshot(snapshot);
  factory MingaUser.fromMap(Map<String, dynamic> data) =>
      _$mingaUserFromMap(data);
  Map<String, dynamic> toMap() => _$mingaUserToMap(this);
}
