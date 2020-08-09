import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_api/firestore_api.dart';
import 'donation_model.dart';
import 'donation_service.dart';

class DonationEvent {
  final bool proactive;
  DonationEvent(this.proactive);
  factory DonationEvent.fromDonationChange(Donation before, Donation after) {
    _nullChecker(dynamic before, dynamic after) =>
        before == null && after != null;

    // 1.
    if (_nullChecker(before, after)) {
      return DonationCreatedEvent(after.created, false);
    }

    // 2.
    if (_nullChecker(before.centerRef, after.centerRef) &&
        _nullChecker(before.centerAdmins, after.centerAdmins)) {
      return DonationCenterAssignedEvent(after.centerRef, false);
    }

    // 3.
    if (_nullChecker(before.needsDeliveryService, after.needsDeliveryService) &&
        _nullChecker(before.deliveryServiceRef, after.deliveryServiceRef)) {
      return DonationNeedsDeliveryServiceEvent(false);
    }

    // 4.
    if (_nullChecker(before.collectorRef, after.collectorRef)) {
      return DonationDeliveryServiceStaffedEvent(false);
    }

    // 5.
    if (_nullChecker(before.pickedUp, after.pickedUp)) {
      return DonationPickedUpEvent(after.pickedUp, false);
    }

    // 6.
    if (_nullChecker(before.delivered, after.delivered)) {
      return DonationDeliveredEvent(after.delivered, false);
    }

    // 7.
    if (_nullChecker(before, after)) {
      return DonationDeliveryVerifiedEvent(after.deliveryVerified, false);
    }

    throw ArgumentError('can not detect event');
  }
}

class DonationCreatedEvent extends DonationEvent {
  final DateTime created;
  DonationCreatedEvent(this.created, bool proactive) : super(proactive);
}

class DonationCenterAssignedEvent extends DonationEvent {
  final DocumentReference centerRef;

  DonationCenterAssignedEvent(this.centerRef, bool proactive)
      : super(proactive);
}

class DonationNeedsDeliveryServiceEvent extends DonationEvent {
  DonationNeedsDeliveryServiceEvent(bool proactive) : super(proactive);
}

class DonationDeliveryServiceStaffedEvent extends DonationEvent {
  DonationDeliveryServiceStaffedEvent(bool proactive) : super(proactive);
}

class DonationPickedUpEvent extends DonationEvent {
  final DateTime pickedUp;

  DonationPickedUpEvent(this.pickedUp, bool proactive) : super(proactive);
}

class DonationDeliveredEvent extends DonationEvent {
  final DateTime delivered;

  DonationDeliveredEvent(this.delivered, bool proactive) : super(proactive);
}

class DonationDeliveryVerifiedEvent extends DonationEvent {
  final DateTime deliveryVerified;
  DonationDeliveryVerifiedEvent(this.deliveryVerified, bool proactive)
      : super(proactive);
}

class DonationState extends Equatable {
  @override
  List<Object> get props => [];
}

class DonationSuccessState extends DonationState {
  final String message;

  DonationSuccessState(this.message);
}

class DonationFailureState extends DonationState {
  final String message;

  DonationFailureState(this.message);
}

class DonationSnapshotState extends DonationState {
  final Donation donation;

  DonationSnapshotState(this.donation);
}

class DonationBloc extends Bloc<DonationEvent, DonationState> {
  final DonationService _donationService;

  DonationBloc(this._donationService)
      : super(DonationSnapshotState(_donationService.donation));

  @override
  Stream<DonationState> mapEventToState(DonationEvent event) async* {
    if (event.proactive) {
      try {
        // 1. create Donation
        // ...
        // 2.
        if (event is DonationCenterAssignedEvent) {}
        // 3.
        if (event is DonationNeedsDeliveryServiceEvent) {}
        // 4.
        if (event is DonationDeliveryServiceStaffedEvent) {}
        // 5.
        if (event is DonationPickedUpEvent) {}
        // 6.
        if (event is DonationDeliveredEvent) {}
        // 7.
        if (event is DonationDeliveryVerifiedEvent) {}
      } catch (e) {
        DonationFailureState(e);
      }
    } else {
      // if the event is not proactive, it means we are only listening to this events, not actually trigger them
      yield DonationSnapshotState(_donationService.donation);
    }
  }
}
