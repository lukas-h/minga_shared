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

    if (_nullChecker(before, after)) {
      return DonationCreatedEvent(after.created, false);
    }

    if (_nullChecker(before.centerRef, after.centerRef) &&
        _nullChecker(before.centerAdmins, after.centerAdmins)) {
      return DonationCenterAssignedEvent(after.centerRef, false);
    }

    if (_nullChecker(before.needsDeliveryService, after.needsDeliveryService) &&
        _nullChecker(before.deliveryServiceRef, after.deliveryServiceRef)) {
      return DonationNeedsDeliveryServiceEvent(false);
    }

    if (_nullChecker(before.assignedCollectorRef, after.assignedCollectorRef)) {
      return DonationDeliveryServiceStaffedEvent(false);
    }

    if (_nullChecker(before.pickedUp, after.pickedUp)) {
      return DonationPickedUpEvent(after.pickedUp, false);
    }

    if (_nullChecker(before.delivered, after.delivered)) {
      return DonationDeliveredEvent(after.delivered, false);
    }

    if (_nullChecker(before, after)) {
      return DonationDeliveryVerifiedEvent(after.deliveryVerified, false);
    }

    throw ArgumentError('can not detect event');
  }
}

/// 1st step
class DonationCreatedEvent extends DonationEvent {
  final DateTime created;
  DonationCreatedEvent(this.created, bool proactive) : super(proactive);
}

/// 2nd step
class DonationCenterAssignedEvent extends DonationEvent {
  final DocumentReference centerRef;

  DonationCenterAssignedEvent(this.centerRef, bool proactive)
      : super(proactive);
}

/// 3rd step
class DonationNeedsDeliveryServiceEvent extends DonationEvent {
  DonationNeedsDeliveryServiceEvent(bool proactive) : super(proactive);
}

/// 4th step
class DonationDeliveryServiceStaffedEvent extends DonationEvent {
  DonationDeliveryServiceStaffedEvent(bool proactive) : super(proactive);
}

/// 5th step
class DonationPickedUpEvent extends DonationEvent {
  final DateTime pickedUp;

  DonationPickedUpEvent(this.pickedUp, bool proactive) : super(proactive);
}

/// 6th step
class DonationDeliveredEvent extends DonationEvent {
  final DateTime delivered;

  DonationDeliveredEvent(this.delivered, bool proactive) : super(proactive);
}

/// 7th step
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
        // TODO implement
        if (event is DonationCenterAssignedEvent) {}
        if (event is DonationNeedsDeliveryServiceEvent) {}
        if (event is DonationDeliveryServiceStaffedEvent) {}
        if (event is DonationPickedUpEvent) {}
        if (event is DonationDeliveredEvent) {}
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
