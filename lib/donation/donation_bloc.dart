import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'donation_model.dart';

class DonationState extends Equatable {
  @override
  List<Object> get props => [];
}

class DonationMessageState extends DonationState {
  final String message;

  DonationMessageState(this.message);
}

class DonationFailureState extends DonationState {
  final String message;

  DonationFailureState(this.message);
}

class DonationSnapshotState extends DonationState {
  final DonationModel donation;

  DonationSnapshotState(this.donation);
}

class DonationBloc extends Cubit<DonationState> {
  DonationBloc() : super(null);
}
