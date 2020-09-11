import 'package:firestore_api/firestore_api.dart';
import '../actions.dart';
import 'center_model.dart';

class CreateCenterAction extends DocumentAction<CenterModel> {
  CreateCenterAction(Firestore firestore) : super(firestore);

  @override
  Future<ActionResult> runActionInternal(CenterModel model) {
    // TODO: implement runActionInternal
    throw UnimplementedError();
  }
}
