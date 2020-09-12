import 'package:firestore_api/firestore_api.dart';
import 'package:minga_shared/user/profile_model.dart';
import 'package:minga_shared/user/user_model.dart';
import '../actions.dart';
import 'transaction_model.dart';

class CreateTransaction extends DocumentAction<TransactionModel> {
  final DocumentReference senderRef;
  CreateTransaction(Firestore firestore, this.senderRef) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(TransactionModel senderModel) async {
    try {
      senderModel
        ..selfRef ??= senderRef.collection('transactions').document()
        ..created ??= DateTime.now()
        ..outgoing = true
        ..senderRef = senderRef;
      TransactionModel receiverModel = TransactionModel(
        selfRef: senderModel.receiverRef
            .collection('transactions')
            .document(senderModel.selfRef.documentID),
        associatedObjectRef: senderModel.associatedObjectRef,
        created: senderModel.created,
        impactPoints: senderModel.impactPoints,
        label: senderModel.label,
        notes: senderModel.notes,
        outgoing: false,
        receiverRef: senderModel.receiverRef,
        senderRef: senderModel.senderRef,
        type: senderModel.type,
      );

      await addSetDataToBatch(senderModel.selfRef, senderModel.toMap());
      await addSetDataToBatch(receiverModel.selfRef, receiverModel.toMap());
      return ActionResult.success(
        senderModel.selfRef,
        'TransactionModel',
        ActionType.create,
      );
    } catch (e) {
      return ActionResult.failure(
        senderModel.selfRef,
        'TransactionModel',
        ActionType.create,
        message: e.toString(),
      );
    }
  }
}

// cloud function running after transaction create

class UpdateImpactAction extends DocumentTransaction<TransactionModel> {
  UpdateImpactAction(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(
      TransactionModel model, Transaction t) async {
    try {
      var user = UserModel.fromSnapshot(
          await t.get(model.outgoing ? model.senderRef : model.receiverRef));
      var profile = ProfileModel.fromSnapshot(await t.get(user.profileRef));

      // balance
      num impactBalance =
          model.outgoing ? -model.impactPoints : model.impactPoints;
      if (user.impactBalance == null) {
        user.impactBalance = impactBalance;
      } else {
        user.impactBalance += impactBalance;
      }

      // total
      num totalImpact = model.outgoing ? 0 : model.impactPoints;
      if (user.totalImpact == null) {
        user.totalImpact = totalImpact;
      } else {
        user.totalImpact += totalImpact;
      }

      await t.set(user.selfRef, user.toMap());

      if (profile.showImpact) {
        profile.totalImpact = user.totalImpact;
        await t.set(profile.selfRef, user.toMap());
      }

      return ActionResult.success(
        model.selfRef,
        'TransactionModel',
        ActionType.update,
      );
    } catch (e) {
      return ActionResult.failure(
        model.selfRef,
        'TransactionModel',
        ActionType.update,
        message: e.toString(),
      );
    }
  }
}
