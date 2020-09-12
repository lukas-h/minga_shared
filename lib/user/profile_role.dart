import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'profile_role.g.dart';

@FirestoreDocument()
class ProfileRoleModel {
  DocumentReference selfRef; // same id   as the the profile
  DocumentReference profileRef;
  String label;
  String type;
  ProfileRoleModel({
    this.selfRef,
    this.label,
    this.profileRef,
    this.type,
  });
  factory ProfileRoleModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$profileRoleModelFromSnapshot(snapshot);
  factory ProfileRoleModel.fromMap(Map<String, dynamic> data) =>
      _$profileRoleModelFromMap(data);
  Map<String, dynamic> toMap() => _$profileRoleModelToMap(this);
}
