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
