import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'voluntary_work_category.g.dart';

@FirestoreDocument()
class VoluntaryWorkType {
  DocumentReference selfRef;
  num averagePriceInPeso;
  DocumentReference categoryRef;
  String image;
  String label;
  num points;
  bool superCategory;
  String unit;

  VoluntaryWorkType({
    this.selfRef,
    this.averagePriceInPeso,
    this.categoryRef,
    this.image,
    this.label,
    this.points,
    this.superCategory,
    this.unit,
  });

  factory VoluntaryWorkType.fromSnapshot(DocumentSnapshot snapshot) =>
      _$voluntaryWorkTypeFromSnapshot(snapshot);
  factory VoluntaryWorkType.fromMap(Map<String, dynamic> data) =>
      _$voluntaryWorkTypeFromMap(data);

  Map<String, dynamic> toMap() => _$voluntaryWorkTypeToMap(this);
}
