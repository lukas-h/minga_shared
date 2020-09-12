import 'package:firestore_api/firestore_api.dart';
import 'package:minga_shared/auth/auth_bloc.dart';
import 'profile_model.dart';
import '../actions.dart';
import 'profile_role.dart';
import 'user_model.dart';

class UserQuery extends DocumentQuery<UserModel> {
  UserQuery(DocumentReference query) : super(query);
  UserQuery.fromAuthUser(AuthUser user, Firestore firestore)
      : super(firestore.collection('users').document(user.uid));

  @override
  UserModel mapQuery(DocumentSnapshot snapshot) =>
      UserModel.fromSnapshot(snapshot);
}

class ProfileQuery extends DocumentQuery<ProfileModel> {
  ProfileQuery(DocumentReference query) : super(query);

  @override
  ProfileModel mapQuery(DocumentSnapshot snapshot) =>
      ProfileModel.fromSnapshot(snapshot);
}

class CreateUserAction extends DocumentAction<AuthUser> {
  CreateUserAction(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(AuthUser model) async {
    try {
      var userModel = UserModel(
        selfRef: firestore.collection('users').document(model.uid),
        email: model.email,
        label: model.label,
        phone: model.phone,
        impactBalance: 0,
        profileRef: null,
        totalImpact: 0,
      );

      await addSetDataToBatch(userModel.selfRef, userModel.toMap());

      return ActionResult.success(
        userModel.selfRef,
        'UserModel',
        ActionType.create,
      );
    } catch (e) {
      return ActionResult.failure(
        null,
        'UserModel',
        ActionType.create,
        message: e.toString(),
      );
    }
  }
}

class FinishOnboardingAction extends DocumentAction<ProfileModel> {
  UserModel userModel;

  FinishOnboardingAction(Firestore firestore, this.userModel)
      : super(firestore);

  @override
  Future<ActionResult> runActionInternal(ProfileModel model) async {
    try {
      model
        ..selfRef ??= firestore.collection('profiles').document()
        ..userDeleted = null
        ..totalImpact = model.showImpact ? userModel.totalImpact : null;

      await addSetDataToBatch(model.selfRef, model.toMap());

      userModel = UserModel(
        selfRef: userModel.selfRef,
        totalImpact: null,
        impactBalance: null,
        email: model.email,
        phone: model.phone,
        label: model.label,
        profileRef: model.selfRef,
      );

      await addUpdateToBatch(userModel.selfRef, userModel.toMap());

      return ActionResult.success(
        model.selfRef,
        'UserModel',
        ActionType.create,
      );
    } catch (e) {
      return ActionResult.failure(
        model.selfRef,
        'UserModel',
        ActionType.create,
        message: e.toString(),
      );
    }
  }
}

class UpdateUserAction extends DocumentAction<ProfileModel> {
  UserModel userModel;
  UpdateUserAction(Firestore firestore, this.userModel) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(ProfileModel model) async {
    try {
      model
        ..totalImpact = null
        ..userDeleted = null;

      if (!model.showEmail) {
        model.email = null;
      }

      if (!model.showPhone) {
        model.email = null;
      }

      userModel = UserModel(
        selfRef: userModel.selfRef,
        label: model.label,
        email: model.email,
        phone: model.phone,
      );

      await addUpdateToBatch(model.selfRef, model.toMap());
      await addUpdateToBatch(userModel.selfRef, userModel.toMap());

      return ActionResult.success(
        model.selfRef,
        'ProfileModel',
        ActionType.update,
      );
    } catch (e) {
      return ActionResult.failure(
        model.selfRef,
        'ProfileModel',
        ActionType.update,
        message: e.toString(),
      );
    }
  }
}

// trigger cloud function after profile was updated
class UpdateUserDataAction extends DocumentAction<ProfileModel> {
  UpdateUserDataAction(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(model) async {
    try {
      var querySnapshot = await firestore
          .collectionGroup('roles')
          .where('profileRef', isEqualTo: model.selfRef)
          .getDocuments();

      for (var role in querySnapshot.documents) {
        var updatedRole = ProfileRoleModel(
          label: model.label,
          selfRef: role.reference,
        );
        addUpdateToBatch(
          updatedRole.selfRef,
          updatedRole.toMap(),
        );
      }
      return ActionResult.success(
        null,
        'UserModel',
        ActionType.delete,
      );
    } catch (e) {
      return ActionResult.failure(
        null,
        'UserModel',
        ActionType.delete,
        message: e.toString(),
      );
    }
  }
}

class DeleteUserAction extends DocumentAction<UserModel> {
  DeleteUserAction(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(UserModel model) async {
    try {
      await addUpdateToBatch(
          model.profileRef,
          ProfileModel(
            selfRef: model.profileRef,
            anonymizeChats: true,
            anonymizeDonations: true,
            email: null,
            label: 'inactive profile',
            location: null,
            phone: null,
            showEmail: false,
            showImpact: false,
            showPhone: false,
            totalImpact: null,
            userDeleted: true,
          ).toMap());
      await addDeleteToBatch(model.selfRef);
      return ActionResult.success(
        model.selfRef,
        'UserModel',
        ActionType.delete,
      );
    } catch (e) {
      return ActionResult.failure(
        model.selfRef,
        'UserModel',
        ActionType.delete,
        message: e.toString(),
      );
    }
  }
}

// trigger by cloud function after user was deleted
class DeleteUserDataAction extends DocumentAction<UserModel> {
  DeleteUserDataAction(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(UserModel userBeforeDeletion) async {
    try {
      var querySnapshot = await firestore
          .collectionGroup('roles')
          .where('profileRef', isEqualTo: userBeforeDeletion.profileRef)
          .getDocuments();

      for (var role in querySnapshot.documents) {
        addDeleteToBatch(role.reference);
      }
      return ActionResult.success(
        null,
        'UserModel',
        ActionType.delete,
      );
    } catch (e) {
      return ActionResult.failure(
        null,
        'UserModel',
        ActionType.delete,
        message: e.toString(),
      );
    }
  }
}
