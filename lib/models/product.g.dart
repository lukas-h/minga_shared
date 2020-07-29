// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// FirestoreDocumentGenerator
// **************************************************************************

ProductEntry _$productEntryFromSnapshot(DocumentSnapshot snapshot) {
  return ProductEntry(
    selfRef: snapshot.reference,
    price: snapshot.data["price"] is double
        ? snapshot.data["price"]
        : double.parse(snapshot.data["price"]),
    description: snapshot.data["description"] is String
        ? snapshot.data["description"]
        : snapshot.data["description"].toString(),
    condition: ProductCondition.fromMap(
        Map<String, dynamic>.from(snapshot.data["condition"])),
    expiryDate: snapshot.data["expiryDate"] is DateTime
        ? snapshot.data["expiryDate"]
        : DateTime.tryParse(snapshot.data["expiryDate"].toString()),
    created: snapshot.data["created"] is DateTime
        ? snapshot.data["created"]
        : DateTime.tryParse(snapshot.data["created"].toString()),
    productRef: snapshot.data["productRef"],
  );
}

ProductEntry _$productEntryFromMap(Map<String, dynamic> data) {
  return ProductEntry(
    price:
        data["price"] is double ? data["price"] : double.parse(data["price"]),
    description: data["description"] is String
        ? data["description"]
        : data["description"].toString(),
    condition:
        ProductCondition.fromMap(Map<String, dynamic>.from(data["condition"])),
    expiryDate: data["expiryDate"] is DateTime
        ? data["expiryDate"]
        : DateTime.tryParse(data["expiryDate"].toString()),
    created: data["created"] is DateTime
        ? data["created"]
        : DateTime.tryParse(data["created"].toString()),
    productRef: data["productRef"],
  );
}

Map<String, dynamic> _$productEntryToMap(ProductEntry model) {
  return <String, dynamic>{
    "price": model.price,
    "description": model.description,
    "condition": model.condition.toMap(),
    "expiryDate": model.expiryDate,
    "created": model.created,
    "productRef": model.productRef,
  };
}

ProductSize _$productSizeFromSnapshot(DocumentSnapshot snapshot) {
  return ProductSize(
    label: snapshot.data["label"] is String
        ? snapshot.data["label"]
        : snapshot.data["label"].toString(),
    from: snapshot.data["from"] is int
        ? snapshot.data["from"]
        : int.parse(snapshot.data["from"]),
    to: snapshot.data["to"] is int
        ? snapshot.data["to"]
        : int.parse(snapshot.data["to"]),
    unit: snapshot.data["unit"] is String
        ? snapshot.data["unit"]
        : snapshot.data["unit"].toString(),
  );
}

ProductSize _$productSizeFromMap(Map<String, dynamic> data) {
  return ProductSize(
    label: data["label"] is String ? data["label"] : data["label"].toString(),
    from: data["from"] is int ? data["from"] : int.parse(data["from"]),
    to: data["to"] is int ? data["to"] : int.parse(data["to"]),
    unit: data["unit"] is String ? data["unit"] : data["unit"].toString(),
  );
}

Map<String, dynamic> _$productSizeToMap(ProductSize model) {
  return <String, dynamic>{
    "label": model.label,
    "from": model.from,
    "to": model.to,
    "unit": model.unit,
  };
}

ProductCondition _$productConditionFromSnapshot(DocumentSnapshot snapshot) {
  return ProductCondition(
    label: snapshot.data["label"] is String
        ? snapshot.data["label"]
        : snapshot.data["label"].toString(),
    description: snapshot.data["description"] is String
        ? snapshot.data["description"]
        : snapshot.data["description"].toString(),
    durationToExpiry: snapshot.data["durationToExpiry"] is int
        ? snapshot.data["durationToExpiry"]
        : int.parse(snapshot.data["durationToExpiry"]),
  );
}

ProductCondition _$productConditionFromMap(Map<String, dynamic> data) {
  return ProductCondition(
    label: data["label"] is String ? data["label"] : data["label"].toString(),
    description: data["description"] is String
        ? data["description"]
        : data["description"].toString(),
    durationToExpiry: data["durationToExpiry"] is int
        ? data["durationToExpiry"]
        : int.parse(data["durationToExpiry"]),
  );
}

Map<String, dynamic> _$productConditionToMap(ProductCondition model) {
  return <String, dynamic>{
    "label": model.label,
    "description": model.description,
    "durationToExpiry": model.durationToExpiry,
  };
}

Product _$productFromSnapshot(DocumentSnapshot snapshot) {
  return Product(
    selfRef: snapshot.reference,
    label: snapshot.data["label"] is String
        ? snapshot.data["label"]
        : snapshot.data["label"].toString(),
    image: snapshot.data["image"] is String
        ? snapshot.data["image"]
        : snapshot.data["image"].toString(),
    sizes: List.castFrom(snapshot.data["sizes"])
        .map<ProductSize>(
            (data) => ProductSize.fromMap(Map<String, dynamic>.from(data)))
        .toList(),
    conditions: List.castFrom(snapshot.data["conditions"])
        .map<ProductCondition>(
            (data) => ProductCondition.fromMap(Map<String, dynamic>.from(data)))
        .toList(),
  );
}

Product _$productFromMap(Map<String, dynamic> data) {
  return Product(
    label: data["label"] is String ? data["label"] : data["label"].toString(),
    image: data["image"] is String ? data["image"] : data["image"].toString(),
    sizes: List.castFrom(data["sizes"])
        .map<ProductSize>(
            (data) => ProductSize.fromMap(Map<String, dynamic>.from(data)))
        .toList(),
    conditions: List.castFrom(data["conditions"])
        .map<ProductCondition>(
            (data) => ProductCondition.fromMap(Map<String, dynamic>.from(data)))
        .toList(),
  );
}

Map<String, dynamic> _$productToMap(Product model) {
  return <String, dynamic>{
    "label": model.label,
    "image": model.image,
    "sizes": model.sizes.map((data) => data.toMap()).toList(),
    "conditions": model.conditions.map((data) => data.toMap()).toList(),
  };
}
