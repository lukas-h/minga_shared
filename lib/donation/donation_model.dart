import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';
import '../minga_shared.dart';

part 'donation_model.g.dart';

@FirestoreDocument()
class Donation {
  DocumentReference selfRef;
  DocumentReference productClass;
  String label;
  String image;
  ProductCondition condition;
  ProductSize size;

  // step label: user reference
  Map<String, DocumentReference> verificationSteps;

  Donation({
    this.selfRef,
    this.condition,
    this.label,
    this.image,
    this.productClass,
    this.size,
    this.verificationSteps,
  });

  factory Donation.fromSnapshot(DocumentSnapshot snapshot) =>
      _$donationFromSnapshot(snapshot);
  factory Donation.fromMap(Map<String, dynamic> data) =>
      _$donationFromMap(data);
  Map<String, dynamic> toMap() => _$donationToMap(this);
}

@FirestoreDocument()
class VerificationStep {
  DocumentReference selfRef;
  // if it's the service done by a COLLECTOR
  DocumentReference associatedService;
  // payout for completing this step
  DocumentReference associatedPayout;
  // user that is responsible for this step
  DocumentReference associatedUser;

  VerificationStepLabel _label; // TODO label is ignored, but shouldn't
  DateTime completed;
  get label => _label;
  VerificationStep({
    String label,
    this.selfRef,
    this.completed,
    this.associatedPayout,
    this.associatedService,
    this.associatedUser,
  }) : _label = VerificationStepLabel(label);
  factory VerificationStep.fromSnapshot(DocumentSnapshot snapshot) =>
      _$verificationStepFromSnapshot(snapshot);
  factory VerificationStep.fromMap(Map<String, dynamic> data) =>
      _$verificationStepFromMap(data);
  Map<String, dynamic> toMap() => _$verificationStepToMap(this);
}

class VerificationStepLabel {
  String _label;
  DocumentReference selfRef;
  VerificationStepLabel._(this._label);

  factory VerificationStepLabel.created() => VerificationStepLabel._('created');
  factory VerificationStepLabel.pickedUp() =>
      VerificationStepLabel._('pickedUp');
  factory VerificationStepLabel.arrived() => VerificationStepLabel._('arrived');
  VerificationStepLabel(String label) {
    if (['created', 'pickedUp', 'arrived'].contains(label)) {
      _label = label;
    } else {
      throw ArgumentError('illegal value');
    }
  }

  @override
  String toString() => _label;
}
