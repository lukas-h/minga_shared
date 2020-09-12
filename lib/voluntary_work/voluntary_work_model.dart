import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';
part 'voluntary_work_model.g.dart';

class VoluntaryWorkType {
  static final String delivery = 'delivery';
}

@FirestoreDocument()
class VoluntaryWorkModel {
  DocumentReference selfRef;
  DocumentReference centerRef;
  String label;
  String type;
  String description;
  num impactPoints;
  DateTime created;
  DateTime from;
  DateTime to;
  Map<String, dynamic> startLocation;
  Map<String, dynamic> endLocation;

// if accepted
  DocumentReference assignedApplication;
  DocumentReference assignedProfile;

  VoluntaryWorkModel({
    this.selfRef,
    this.centerRef,
    this.label,
    this.description,
    this.impactPoints,
    this.created,
    this.from,
    this.to,
    this.assignedApplication,
    this.assignedProfile,
    this.endLocation,
    this.startLocation,
    this.type,
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
