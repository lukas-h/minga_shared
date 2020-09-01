import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../user/user_model.dart';

/* state */
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginPromptState extends AuthState {}

class RegisterPromptState extends AuthState {}

class AuthProgressState extends AuthState {}

class AuthSuccessState extends AuthState {
  final MingaUser user;

  AuthSuccessState(this.user);
}

class AuthVerifyPhoneState extends AuthState {}

class AuthOnboardingState extends AuthState {
  final MingaUser user;

  AuthOnboardingState(this.user);
}

class AuthMessageState extends AuthState {
  final String message;

  AuthMessageState(this.message);
}

class AuthFailureState extends AuthState {
  final String message;

  AuthFailureState(this.message);
}

abstract class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthProgressState());

  tryLogin();

  loginWithEmailAndPassword(String email, String password);
  registerWithEmailAndPassword(String email, String password);

  // 1. verify phone
  verifyPhone(String phone);
  // 2. log in with credential
  loginWithPhone(String code);

  finishOnboarding(MingaUser user);

  logout();
}
