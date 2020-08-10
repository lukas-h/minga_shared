import 'package:firestore_api/firestore_api.dart';
import 'donation_bloc.dart';
import '../center/center_model.dart';
import '../user/user_model.dart';
import '../discussion/discussion_bloc.dart';
import '../discussion/discussion_service.dart';
import 'donation_model.dart';

class DonationService {
  final Firestore firestore;
  Donation donation;

  DonationService(this.firestore, this.donation);

  get discussion =>
      DiscussionBloc(DiscussionService(firestore, parent: donation.selfRef));

  Future<void> create(Donation newDonation) {
    donation = newDonation ?? donation;
    donation.selfRef ??= firestore.collection('donations').document();
    if (donation.donorRef != null) {
      // TODO throw something
    }

    return newDonation.selfRef.setData(newDonation.toMap());
  }

  Future<void> centerAssigned() {}
  Future<void> needsDeliveryService() {}
  Future<void> deliveryServiceStaffed() {}
  Future<void> pickedUp() {}
  Future<void> delivered() {}
  Future<void> deliveryVerified() {}

  Stream<DonationEvent> get events => donation.selfRef.snapshots.map(
        (snap) => DonationEvent.fromDonationChange(
          donation,
          donation = Donation.fromSnapshot(snap),
        ),
      );
}

class DonationListService {
  final Firestore firestore;
  final Query query;
  DonationListService._(this.firestore, this.query);
  factory DonationListService.forDonor(Firestore firestore, MingaUser user) =>
      _DonorDonationListService(firestore, user);

  factory DonationListService.forCenter(
          Firestore firestore, DistributionCenter center) =>
      _CenterDonationListService(firestore, center);

  Stream<List<Donation>> donationStream() => query.snapshots().map(
        (snap) =>
            snap.documents.map((doc) => Donation.fromSnapshot(doc)).toList(),
      );
}

class _DonorDonationListService extends DonationListService {
  _DonorDonationListService(Firestore firestore, MingaUser user)
      : super._(
            firestore,
            firestore
                .collection('donations')
                .where('donorRef', isEqualTo: user.selfRef));
  Future<void> setDonation(Donation donation) =>
      firestore.collection('donations').document().setData(donation.toMap());
}

class _CenterDonationListService extends DonationListService {
  _CenterDonationListService(Firestore firestore, DistributionCenter center)
      : super._(
            firestore,
            firestore
                .collection('donations')
                .where('centerRef', isEqualTo: center.selfRef));
}
