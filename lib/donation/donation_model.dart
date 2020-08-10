import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';
import '../minga_shared.dart';

part 'donation_model.g.dart';

// class DonationEventString {
//   static String created = 'created';
//   static String centerAssigned = 'centerAssigned';
//   static String needsDeliveryService = 'needsDeliveryService';
//   static String deliveryServiceStaffed = 'deliveryServiceStaffed';
//   static String pickedUp = 'pickedUp';
//   static String delivered = 'delivered';
//   static String deliveryVerified = 'pickedUp';
// }

@FirestoreDocument()
class Donation {
  DocumentReference selfRef;

  DocumentReference productClassRef;
  String label;
  String image;
  ProductSize size;
  ProductCondition condition;
  int maximumDelayForPickup; // in hours

  String notes;
  DateTime created;
  DateTime expiryDate;

  DocumentReference donorRef;
  DocumentReference donorPayoutRef;

  bool needsDeliveryService;
  DocumentReference deliveryServiceRef;
  DocumentReference collectorRef;
  DateTime pickedUp;
  DateTime delivered;

  DateTime deliveryVerified;
  DocumentReference centerRef;
  List<DocumentReference> centerAdmins;

  Donation({
    this.selfRef,
    this.condition,
    this.label,
    this.image,
    this.productClassRef,
    this.size,
    this.centerRef,
    this.centerAdmins,
    this.donorRef,
    this.deliveryServiceRef,
    this.needsDeliveryService,
    this.created,
    this.deliveryVerified,
    this.donorPayoutRef,
    this.maximumDelayForPickup,
    this.collectorRef,
    this.delivered,
    this.pickedUp,
    this.notes,
    this.expiryDate,
  });

  factory Donation.fromProductClass(
    ProductClass productClass,
    DocumentReference donorRef,
    DateTime expiryDate, {
    DocumentReference selfRef,
    String label,
    String image,
    DateTime created,
    ProductSize size,
    ProductCondition condition,
  }) =>
      Donation(
        selfRef: selfRef,
        label: label ?? productClass.label,
        expiryDate: expiryDate ?? DateTime.now().add(Duration(days: 1)),
        donorRef: donorRef,
        image: image ?? productClass.image,
        created: created ?? DateTime.now(),
        productClassRef: productClass.selfRef,
        maximumDelayForPickup: productClass.maximumDelayForPickup,
        size: size ?? productClass.sizes?.first,
        condition: condition ?? productClass.conditions?.first,
      );

  factory Donation.fromSnapshot(DocumentSnapshot snapshot) =>
      _$donationFromSnapshot(snapshot);
  factory Donation.fromMap(Map<String, dynamic> data) =>
      _$donationFromMap(data);
  Map<String, dynamic> toMap() => _$donationToMap(this);
}
