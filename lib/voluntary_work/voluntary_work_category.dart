import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

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
}
