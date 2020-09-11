import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_api/firestore_api.dart';
import '../utils/form_validator.dart';
import '../user/user_model.dart';

/* state */
abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginPromptState extends AuthState {
  LoginPromptState();
}

class RegisterPromptState extends AuthState {}

class AuthProgressState extends AuthState {}

class AuthSuccessState extends AuthState {
  final UserModel user;

  AuthSuccessState(this.user);
}

class AuthVerifyPhoneState extends AuthState {}

class AuthOnboardingState extends AuthState {
  final UserModel user;

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

class AuthUser {
  final String uid;
  final String email;
  final String phone;
  final String label;

  AuthUser(this.uid, this.email, this.phone, this.label);
}

typedef PhoneVerificationCompletedImpl = Function(AuthUser user);
typedef PhoneVerificationFailedImpl = Function(String message);
typedef PhoneCodeSentImpl = Function(String message);
typedef OnAuthStateChange = Function(AuthUser user);

abstract class AuthCubit extends Cubit<AuthState> {
  final Firestore firestore;

  AuthCubit(this.firestore) : super(AuthProgressState());

  _emitStateOnLogin(AuthUser user) async {
    // TODO implement
    /* 
    var mingaUser = UserModel(
      selfRef: _userService.collection.document(user.uid),
      email: user.email,
      label: user.label,
      location: null,
      phone: user.phone,
    );

    if (await _userService.exists(mingaUser)) {
      mingaUser = await _userService.getData(mingaUser);

      if (mingaUser.location == null || mingaUser.label == null) {
        emit(AuthOnboardingState(mingaUser));
      } else {
        emit(AuthSuccessState(mingaUser));
      }
    } else {
      await _userService.setData(mingaUser);
      emit(AuthOnboardingState(mingaUser));
    }*/
  }

  void tryLoginImpl(OnAuthStateChange stateChange);
  tryLogin() {
    emit(AuthProgressState());
    try {
      tryLoginImpl((user) {
        if (user != null) {
          _emitStateOnLogin(user);
        } else {
          emit(LoginPromptState());
        }
      });
    } catch (e) {
      print(e);
      emit(AuthFailureState('error logging in'));
      emit(LoginPromptState());
    }
  }

  loginPrompt() {
    emit(LoginPromptState());
  }

  registerPrompt() {
    emit(RegisterPromptState());
  }

  Future<AuthUser> registerWithEmailAndPasswordImpl(
      String email, String password);
  loginWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthProgressState());
      if (!FormValidator.validateEmail(email) ||
          !FormValidator.validatePassword(password)) {
        throw 'Invalid  mail or password';
      }
      var user = await loginWithEmailAndPasswordImpl(email, password);
      _emitStateOnLogin(user);
    } catch (e) {
      print(e);
      emit(AuthFailureState('error logging in'));
      emit(LoginPromptState());
    }
  }

  Future<AuthUser> loginWithEmailAndPasswordImpl(String email, String password);
  registerWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthProgressState());
      if (!FormValidator.validateEmail(email) ||
          !FormValidator.validatePassword(password)) {
        throw 'Invalid  mail or password';
      }
      var user = await registerWithEmailAndPasswordImpl(email, password);
      _emitStateOnLogin(user);
    } catch (e) {
      print(e);
      emit(AuthFailureState('error registering'));
      emit(LoginPromptState());
    }
  }

  Future<void> verifyPhoneImpl(
    String number,
    PhoneVerificationCompletedImpl phoneVerificationCompletedImpl,
    PhoneVerificationFailedImpl phoneVerificationFailedImpl,
    PhoneCodeSentImpl phoneCodeSentImpl,
  );
  verifyPhone(String number) async {
    PhoneVerificationCompletedImpl phoneVerificationCompletedImpl =
        (AuthUser user) {
      _emitStateOnLogin(user);
    };
    PhoneVerificationFailedImpl phoneVerificationFailedImpl = (String message) {
      emit(AuthMessageState(message));
    };
    PhoneCodeSentImpl phoneCodeSentImp = (String message) {
      emit(AuthMessageState(message));
    };
    try {
      emit(AuthProgressState());
      if (!FormValidator.validatePhone(number)) throw 'Invalid  phone number';
      await verifyPhoneImpl(number, phoneVerificationCompletedImpl,
          phoneVerificationFailedImpl, phoneCodeSentImp);
      emit(AuthVerifyPhoneState());
    } catch (e) {
      print(e);
      emit(AuthFailureState('error verifying phone'));
      emit(LoginPromptState());
    }
  }

  // 2. log in with credential
  Future<AuthUser> loginWithPhoneImpl(String code);
  // 2. log in with credential
  loginWithPhone(String code) async {
    try {
      emit(AuthProgressState());
      var user = await loginWithPhoneImpl(code);
      _emitStateOnLogin(user);
    } catch (e) {
      print(e);
      emit(AuthFailureState('error logging in'));
      emit(LoginPromptState());
    }
  }

  finishOnboarding(UserModel user) async {
    try {
      emit(AuthProgressState());
      await user.selfRef.update(user.toMap());
      emit(AuthSuccessState(user));
    } catch (e) {
      print(e);
      emit(AuthFailureState('error onboarding'));
      emit(LoginPromptState());
    }
  }

  Future<void> logoutImpl();
  logout() async {
    try {
      emit(AuthProgressState());
      await logoutImpl();
      emit(AuthMessageState('Logged out'));
    } catch (e) {
      print(e);
      emit(AuthFailureState('error logging out'));
      emit(LoginPromptState());
    }
  }
}
