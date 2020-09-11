import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';
part 'voluntary_work_model.g.dart';

@FirestoreDocument()
class VoluntaryWorkModel {
  DocumentReference selfRef;
  DocumentReference centerRef;
  DocumentReference categoryRef;
  String label;
  String description;
  num impactPoints;
  DateTime created;
  DateTime from;
  DateTime to;

// if accepted
  DocumentReference assignedApplication;
  DocumentReference assignedProfile;

  VoluntaryWorkModel({
    this.selfRef,
    this.centerRef,
    this.categoryRef,
    this.label,
    this.description,
    this.impactPoints,
    this.created,
    this.from,
    this.to,
    this.assignedApplication,
    this.assignedProfile,
  });

  factory VoluntaryWorkModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$voluntaryWorkModelFromSnapshot(snapshot);
  factory VoluntaryWorkModel.fromMap(Map<String, dynamic> data) =>
      _$voluntaryWorkModelFromMap(data);
  Map<String, dynamic> toMap() => _$voluntaryWorkModelToMap(this);
}

@FirestoreDocument()
class VoluntaryWorkApplyModel {
  DocumentReference selfRef;
  DocumentReference profileRef;
  DocumentReference voluntaryWorkRef;
  DocumentReference centerRef;
  DateTime created;

  VoluntaryWorkApplyModel({
    this.selfRef,
    this.profileRef,
    this.voluntaryWorkRef,
    this.centerRef,
    this.created,
  });

  factory VoluntaryWorkApplyModel.fromSnapshot(DocumentSnapshot snapshot) =>
      _$voluntaryWorkApplyModelFromSnapshot(snapshot);
  factory VoluntaryWorkApplyModel.fromMap(Map<String, dynamic> data) =>
      _$voluntaryWorkApplyModelFromMap(data);
  Map<String, dynamic> toMap() => _$voluntaryWorkApplyModelToMap(this);
}
