import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'center_model.g.dart';

@FirestoreDocument()
class DistributionCenter {
  DocumentReference selfRef;
  String label;
  List<DocumentReference> admins;
  DistributionCenter({
    this.admins,
    this.label,
    this.selfRef,
  });
  factory DistributionCenter.fromSnapshot(DocumentSnapshot snapshot) =>
      _$distributionCenterFromSnapshot(snapshot);
  factory DistributionCenter.fromMap(Map<String, dynamic> data) =>
      _$distributionCenterFromMap(data);
  Map<String, dynamic> toMap() => _$distributionCenterToMap(this);
}
