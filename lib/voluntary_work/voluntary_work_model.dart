import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';
part 'voluntary_work_model.g.dart';

class VoluntaryWorkType {
  static const String delivery = 'delivery';
  static const String serveFood = 'serveFood';
  static const String prepareFood = 'prepareFood';
  static const String clean = 'clean';
  static const String repair = 'repair';
  static const String gardening = 'gardening';
  static const String coordinate = 'coordinate';
  static const String healthcare = 'healthcare';
  static const String teaching = 'teaching';
}

Map<String, String> voluntaryWorkLabels = {
  VoluntaryWorkType.clean: 'Cleaning',
  VoluntaryWorkType.serveFood: 'Serve Food',
  VoluntaryWorkType.prepareFood: 'Prepare Food',
  VoluntaryWorkType.delivery: 'Deliver',
  VoluntaryWorkType.gardening: 'Gardening',
  VoluntaryWorkType.teaching: 'Help Teach',
  VoluntaryWorkType.repair: 'Repair',
  VoluntaryWorkType.coordinate: 'Coordinate',
  VoluntaryWorkType.healthcare: 'Healthcare'
};

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
  DateTime started;
  DateTime finished;
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
    this.finished,
    this.started,
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
