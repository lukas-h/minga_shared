import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firestore_api/firestore_api.dart';
import 'discussion_model.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionItem entry;
  DiscussionBloc(this.entry) : super(DiscussionLoading());

  Stream<DiscussionState> _mapLoadingEventToState() async* {
    try {
      var snap = await entry.selfRef.collection('answers').getDocuments();
      List<DiscussionItem> discussionItems = [
        entry,
        ...snap.documents
            .map((DocumentSnapshot docSnap) =>
                DiscussionItem.fromSnapshot(docSnap))
            .toList()
      ];
      yield DiscussionSuccess(discussionItems);
    } catch (e) {
      yield DiscussionFailure();
    }
  }

  @override
  Stream<DiscussionState> mapEventToState(DiscussionEvent event) async* {
    if (event is LoadDiscussion) {
      yield DiscussionLoading();

      yield* _mapLoadingEventToState();
    }
    if (event is CreateAnswer) {
      await entry.selfRef
          .collection('answers')
          .document()
          .setData(event.discussion.toMap());
      add(LoadDiscussion());
    }
    if (event is UpdateDiscussionItem) {
      await event.discussion.selfRef.update(event.discussion.toMap());
      add(LoadDiscussion());
    }
    if (event is DeleteDiscussionItem) {
      if (event.discussion.isEntry) {
        await event.discussion.selfRef.delete();
        add(LoadDiscussion());
      }
    }
  }
}

abstract class DiscussionEvent {}

class LoadDiscussion extends DiscussionEvent {}

class CreateAnswer extends DiscussionEvent {
  final DiscussionItem discussion;

  CreateAnswer(this.discussion);
}

class UpdateDiscussionItem extends DiscussionEvent {
  final DiscussionItem discussion;

  UpdateDiscussionItem(this.discussion);
}

class DeleteDiscussionItem extends DiscussionEvent {
  final DiscussionItem discussion;

  DeleteDiscussionItem(this.discussion);
}

abstract class DiscussionState extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscussionLoading extends DiscussionState {}

class DiscussionSuccess extends DiscussionState {
  final List<DiscussionItem> discussionItems;

  DiscussionSuccess(this.discussionItems);
}

class DiscussionFailure extends DiscussionState {}
