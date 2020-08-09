import 'package:firestore_annotations/firestore_annotations.dart';
import 'package:firestore_api/firestore_api.dart';

part 'discussion_model.g.dart';

@FirestoreDocument()
class DiscussionItem {
  DocumentReference selfRef;
  DocumentReference userRef;
  DateTime created;
  String label;
  String description;
  bool isEntry;
  String locationLabel;
  List<int> coordinates;
  DiscussionItem({
    this.created,
    this.description,
    this.label,
    this.selfRef,
    this.isEntry,
    this.userRef,
    this.coordinates,
    this.locationLabel,
  });

  factory DiscussionItem.fromSnapshot(DocumentSnapshot snapshot) =>
      _$discussionItemFromSnapshot(snapshot);
  factory DiscussionItem.fromMap(Map<String, dynamic> data) =>
      _$discussionItemFromMap(data);
  Map<String, dynamic> toMap() => _$discussionItemToMap(this);
}
