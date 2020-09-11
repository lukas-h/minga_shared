import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'user_model.g.dart';

@FirestoreDocument()
class UserModel {
  DocumentReference selfRef;

  String label; // name

  String email;

  String phone;

  Map<String, dynamic> location;

  num impactBalance;

  num totalImpact;

  UserModel({
    this.selfRef,
    this.label,
    this.email,
    this.phone,
    this.location,
    this.impactBalance,
    this.totalImpact,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$userModelFromSnapshot(snapshot);
  factory UserModel.fromMap(Map<String, dynamic> data) =>
      _$userModelFromMap(data);
  Map<String, dynamic> toMap() => _$userModelToMap(this);
}
