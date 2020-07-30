import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'product.g.dart';

@FirestoreDocument()
class ProductEntry {
  DocumentReference selfRef;
  double price;
  String description;
  ProductCondition condition;
  ProductSize size;
  DateTime expiryDate;
  final DateTime created;
  DocumentReference productRef;

  ProductEntry({
    this.selfRef,
    this.price,
    this.description,
    this.condition,
    this.size,
    this.expiryDate,
    this.created,
    this.productRef,
  });

  factory ProductEntry.fromSnapshot(DocumentSnapshot snapshot) =>
      _$productEntryFromSnapshot(snapshot);
  factory ProductEntry.fromMap(Map<String, dynamic> data) =>
      _$productEntryFromMap(data);
  Map<String, dynamic> toMap() => _$productEntryToMap(this);
}

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
  final String label;
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
class Product {
  DocumentReference selfRef;
  String label;
  String image;
  List<ProductSize> sizes;
  List<ProductCondition> conditions;
  int maximumDelayForPickup; // in milliseconds
  bool superCategory;

  Product({
    this.selfRef,
    this.label,
    this.image,
    this.sizes,
    this.conditions,
    this.maximumDelayForPickup,
    this.superCategory,
  });

  factory Product.create(Firestore f) => Product(
        selfRef: f.collection('product').document(),
        label: '',
        image: '',
        conditions: [],
        maximumDelayForPickup: Duration(hours: 12).inMilliseconds,
        sizes: [],
        superCategory: false,
      );

  factory Product.fromSnapshot(DocumentSnapshot snapshot) =>
      _$productFromSnapshot(snapshot);
  factory Product.fromMap(Map<String, dynamic> data) => _$productFromMap(data);
  Map<String, dynamic> toMap() => _$productToMap(this);
}
