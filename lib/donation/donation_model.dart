import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';
import '../product_category/product_category.dart';

part 'donation_model.g.dart';

class DonationUpdateType {
  static final String created = 'created';
  static final String assignedToCenter = 'assignedToCenter';
  static final String needsDelivery = 'needsDelivery';
  static final String openForApplication = 'openForApplication';
  static final String applicationClosed = 'applicationClosed ';
  static final String pickedUp = 'pickedUp';
  static final String delivered = 'delivered';
  static final String deliveryConfirmed = 'deliveryConfirmed';
  static final String closed = 'closed';
}

@FirestoreDocument()
class DonationUpdateModel {
  DocumentReference selfRef;
  String type;
  DateTime created;
  DonationUpdateModel({
    this.selfRef,
    this.created,
    this.type,
  });

  factory DonationUpdateModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$donationUpdateModelFromSnapshot(snapshot);

  factory DonationUpdateModel.fromMap(Map<String, dynamic> data) =>
      _$donationUpdateModelFromMap(data);

  Map<String, dynamic> toMap() => _$donationUpdateModelToMap(this);
}

class DonationRoleTypes {
  static final String donor = 'donor';
  static final String centerAdmin = 'centerAdmin';
  static final String collector = 'collector';
}

@FirestoreDocument()
class DonationModel {
  DocumentReference selfRef;

  DocumentReference productCategoryRef;
  String label;
  String image;
  ProductSize size;
  ProductCondition condition;
  int maximumDelayForPickup; // in hours

  String notes;
  DateTime expiryDate;

  DocumentReference donorRef;

  String deliveryMapImage;
  DocumentReference centerRef;
  String centerLabel;
  Map<String, dynamic> startLocation;
  Map<String, dynamic> endLocation;

  DonationModel({
    this.selfRef,
    this.condition,
    this.label,
    this.image,
    this.productCategoryRef,
    this.size,
    this.centerRef,
    this.donorRef,
    this.maximumDelayForPickup,
    this.notes,
    this.expiryDate,
    this.deliveryMapImage,
    this.endLocation,
    this.startLocation,
    this.centerLabel,
  });

  factory DonationModel.fromProductCategory(
    ProductCategory productCategory,
    DocumentReference donorRef,
    DateTime expiryDate, {
    DocumentReference selfRef,
    String label,
    String image,
    DateTime created,
    ProductSize size,
    ProductCondition condition,
  }) =>
      DonationModel(
        selfRef: selfRef,
        label: label ?? productCategory.label,
        expiryDate: expiryDate ?? DateTime.now().add(Duration(days: 1)),
        donorRef: donorRef,
        image: image ?? productCategory.image,
        productCategoryRef: productCategory.selfRef,
        maximumDelayForPickup: productCategory.maximumDelayForPickup,
        size: size ?? productCategory.sizes?.first,
        condition: condition ?? productCategory.conditions?.first,
      );

  factory DonationModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$donationModelFromSnapshot(snapshot);
  factory DonationModel.fromMap(Map<String, dynamic> data) =>
      _$donationModelFromMap(data);
  Map<String, dynamic> toMap() => _$donationModelToMap(this);
}
