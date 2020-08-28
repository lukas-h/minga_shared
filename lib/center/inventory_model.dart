import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

import '../minga_shared.dart';

part 'inventory_model.g.dart';

@FirestoreDocument()
class InventoryItem {
  DocumentReference selfRef;

  DocumentReference productClassRef;
  String label;
  String image;
  ProductSize size;
  ProductCondition condition;

  String notes;
  DateTime created;
  DateTime expiryDate;
  DateTime delivered;

  DocumentReference donationRef;
  InventoryItem({
    this.condition,
    this.created,
    this.delivered,
    this.donationRef,
    this.label,
    this.selfRef,
    this.expiryDate,
    this.image,
    this.notes,
    this.productClassRef,
    this.size,
  });
  factory InventoryItem.fromSnapshot(DocumentSnapshot snapshot) =>
      _$inventoryItemFromSnapshot(snapshot);
  factory InventoryItem.fromMap(Map<String, dynamic> data) =>
      _$inventoryItemFromMap(data);
  Map<String, dynamic> toMap() => _$inventoryItemToMap(this);
}
