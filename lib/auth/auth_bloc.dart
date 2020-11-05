import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_api/firestore_api.dart';
import '../user/profile_model.dart';
import '../user/user_service.dart';
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
  final ProfileModel profile;

  AuthSuccessState(this.user, this.profile);
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
    var userQuery = UserQuery.fromAuthUser(user, firestore);
    if (await userQuery.exists) {
      var profileRef = (await userQuery.document).profileRef;
      if (profileRef == null) {
        emit(AuthOnboardingState(await userQuery.document));
      } else {
        var profileQuery = ProfileQuery(profileRef);
        emit(AuthSuccessState(
            await userQuery.document, await profileQuery.document));
      }
    } else {
      var result = await CreateUserAction(firestore).runAction(user);
      if (result.successful) {
        emit(AuthOnboardingState(await userQuery.document));
      } else {
        emit(AuthFailureState(result.message));
      }
    }
  }

  finishOnboarding(UserModel user, ProfileModel profile) async {
    try {
      emit(AuthProgressState());
      var result =
          await FinishOnboardingAction(firestore, user).runAction(profile);
      if (result.successful) {
        emit(AuthSuccessState(user, profile));
      } else {
        emit(AuthFailureState(result.message));
      }
    } catch (e) {
      print(e);
      emit(AuthFailureState('error onboarding'));
      emit(LoginPromptState());
    }
  }

  updateUser(UserModel user, ProfileModel profile) async {
    try {
      var result = await UpdateUserAction(firestore, user).runAction(profile);
      if (result.successful) {
        emit(AuthSuccessState(user, profile));
      } else {
        emit(AuthFailureState(result.message));
      }
    } catch (e) {
      print(e);
      emit(AuthFailureState('error updating'));
    }
  }

  deleteUser(UserModel user) async {
    try {
      var result = await DeleteUserAction(firestore).runAction(user);
      if (result.successful) {
        emit(LoginPromptState());
      } else {
        emit(AuthFailureState(result.message));
      }
    } catch (e) {
      print(e);
      emit(AuthFailureState('error deleting'));
    }
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
