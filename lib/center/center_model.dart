import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'center_model.g.dart';

@FirestoreDocument()
class CenterModel {
  DocumentReference selfRef;
  String label;
  Map<String, dynamic> location;

  CenterModel({
    this.label,
    this.selfRef,
    this.location,
  });
  factory CenterModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$centerModelFromSnapshot(snapshot);
  factory CenterModel.fromMap(Map<String, dynamic> data) =>
      _$centerModelFromMap(data);
  Map<String, dynamic> toMap() => _$centerModelToMap(this);
}

@FirestoreDocument()
class CenterRoleModel {
  DocumentReference selfRef; // reference of the profile
  String label;
  CenterRoleModel({
    this.selfRef,
    this.label,
  });
  factory CenterRoleModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$centerRoleModelFromSnapshot(snapshot);
  factory CenterRoleModel.fromMap(Map<String, dynamic> data) =>
      _$centerRoleModelFromMap(data);
  Map<String, dynamic> toMap() => _$centerRoleModelToMap(this);
}
