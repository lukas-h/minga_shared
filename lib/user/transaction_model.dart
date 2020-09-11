import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'transaction_model.g.dart';

class TransactionType {
  static final String donation = 'donation';
  static final String voluntaryWork = 'voluntaryWork';
  static final String directTransfer = 'directTransfer';
  static final String offer = 'offer'; // spent on a food offering
}

@FirestoreDocument()
class TransactionModel {
  DocumentReference selfRef;
  bool outgoing;
  // if outgoing==false, receiverRef is the creators userRef
  DocumentReference receiverRef;
  // if outgoing==true, senderRef is the creators userRef
  DocumentReference senderRef;
  String label;
  String notes;
  String type;
  // the donation, voluntaryWork or food offer
  DocumentReference associatedObjectRef;
  DateTime created;

  num impactPoints;

  TransactionModel({
    this.associatedObjectRef,
    this.created,
    this.impactPoints,
    this.label,
    this.notes,
    this.outgoing,
    this.receiverRef,
    this.selfRef,
    this.senderRef,
    this.type,
  });

  factory TransactionModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$transactionModelFromSnapshot(snapshot);
  factory TransactionModel.fromMap(Map<String, dynamic> data) =>
      _$transactionModelFromMap(data);

  Map<String, dynamic> toMap() => _$transactionModelToMap(this);
}
