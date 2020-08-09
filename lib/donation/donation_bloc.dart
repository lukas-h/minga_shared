import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'donation_model.dart';

abstract class DonationState extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class DonationEvent {}

class DonationBloc extends Bloc<bool, bool> {
  DonationBloc(bool initialState) : super(initialState);

  Donation model;

  @override
  Stream<bool> mapEventToState(bool event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}
