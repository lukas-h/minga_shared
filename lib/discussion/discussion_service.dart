import 'package:firestore_api/firestore_api.dart';

import 'discussion_model.dart';

// TODO migrate to new document actions

class DiscussionService {
  final Firestore firestore;
  final DocumentReference parent;
  final DiscussionItem question;
  final CollectionReference answers;
  DiscussionService(this.firestore, {this.question, this.parent})
      : answers = (parent ?? question.selfRef).collection('answers');

  Future<void> setAnswer(DiscussionItem item) =>
      answers.document().setData(item.toMap());
  Future<void> updateDiscussionItem(DiscussionItem item) =>
      item.selfRef.update(item.toMap());
  Future<void> deleteDiscussionItem(DiscussionItem item) =>
      item.selfRef.delete();
  Stream<List<DiscussionItem>> discussionStream() => answers.snapshots().map(
        (snap) => snap.documents
            .map((doc) => DiscussionItem.fromSnapshot(doc))
            .toList(),
      );
}
