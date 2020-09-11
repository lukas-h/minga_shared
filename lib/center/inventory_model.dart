import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';
import '../product_category/product_category.dart';

part 'inventory_model.g.dart';

@FirestoreDocument()
class InventoryItemModel {
  DocumentReference selfRef;

  DocumentReference productCategoryRef;
  String label;
  String image;
  ProductSize size;
  ProductCondition condition;

  String notes;
  DateTime created;
  DateTime expiryDate;
  DateTime delivered;

  DocumentReference donationRef;
  InventoryItemModel({
    this.condition,
    this.created,
    this.delivered,
    this.donationRef,
    this.label,
    this.selfRef,
    this.expiryDate,
    this.image,
    this.notes,
    this.productCategoryRef,
    this.size,
  });
  factory InventoryItemModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$inventoryItemModelFromSnapshot(snapshot);
  factory InventoryItemModel.fromMap(Map<String, dynamic> data) =>
      _$inventoryItemModelFromMap(data);
  Map<String, dynamic> toMap() => _$inventoryItemModelToMap(this);
}
