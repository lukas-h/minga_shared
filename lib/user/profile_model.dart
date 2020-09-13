import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'profile_model.g.dart';

@FirestoreDocument()
class ProfileModel {
  DocumentReference selfRef;

  bool showPhone;
  bool showEmail;
  bool anonymizeDonations;
  bool anonymizeChats; // only in global chats
  bool showImpact;

  String label;
  String phone;
  String email;

  num totalImpact;
  Map<String, dynamic> location;

  bool userDeleted;

  ProfileModel({
    this.anonymizeChats,
    this.anonymizeDonations,
    this.label,
    this.email,
    this.phone,
    this.selfRef,
    this.showEmail,
    this.showImpact,
    this.showPhone,
    this.totalImpact,
    this.location,
    this.userDeleted,
  });

  factory ProfileModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$profileModelFromSnapshot(snapshot);
  factory ProfileModel.fromMap(Map<String, dynamic> data) =>
      _$profileModelFromMap(data);
  Map<String, dynamic> toMap() => _$profileModelToMap(this);
}
