import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'product_model.g.dart';

@FirestoreDocument(hasSelfRef: false)
class ProductSize {
  String label;
  int from;
  int to;
  String unit;

  ProductSize({
    this.label,
    this.from,
    this.to,
    this.unit,
  });
  factory ProductSize.fromSnapshot(DocumentSnapshot snapshot) =>
      _$productSizeFromSnapshot(snapshot);
  factory ProductSize.fromMap(Map<String, dynamic> data) =>
      _$productSizeFromMap(data);
  Map<String, dynamic> toMap() => _$productSizeToMap(this);
}

@FirestoreDocument(hasSelfRef: false)
class ProductCondition {
  String label;
  String description;
  int durationToExpiry; // milliseconds

  ProductCondition({this.label, this.description, this.durationToExpiry});
  factory ProductCondition.expired() => ProductCondition(label: 'expired');

  factory ProductCondition.fromSnapshot(DocumentSnapshot snapshot) =>
      _$productConditionFromSnapshot(snapshot);
  factory ProductCondition.fromMap(Map<String, dynamic> data) =>
      _$productConditionFromMap(data);
  Map<String, dynamic> toMap() => _$productConditionToMap(this);
}

@FirestoreDocument()
class ProductClass {
  DocumentReference selfRef;
  String label;
  String image;
  List<ProductSize> sizes;
  List<ProductCondition> conditions;
  int maximumDelayForPickup; // in hours

  bool superCategory;
  DocumentReference superCategoryRef;

  num averagePriceInCLPeso;
  int quantity;
  String unit;
  num points;

  ProductClass({
    this.selfRef,
    this.label,
    this.image,
    this.sizes,
    this.conditions,
    this.maximumDelayForPickup,
    this.superCategory,
    this.superCategoryRef,
    this.averagePriceInCLPeso,
    this.points,
    this.quantity,
    this.unit,
  });

  factory ProductClass.create(Firestore f) => ProductClass(
        selfRef: f.collection('product').document(),
        label: '',
        image: '',
        conditions: [],
        maximumDelayForPickup: Duration(hours: 12).inHours,
        sizes: [],
        superCategory: false,
      );

  factory ProductClass.fromSnapshot(DocumentSnapshot snapshot) =>
      _$productClassFromSnapshot(snapshot);
  factory ProductClass.fromMap(Map<String, dynamic> data) =>
      _$productClassFromMap(data);
  Map<String, dynamic> toMap() => _$productClassToMap(this);
}
