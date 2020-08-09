import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'discussion_service.dart';
import 'discussion_model.dart';

abstract class DiscussionEvent {}

class DiscussionLoadingEvent extends DiscussionEvent {}

class DiscussionSnapshotEvent extends DiscussionEvent {
  final List<DiscussionItem> items;

  DiscussionSnapshotEvent(this.items);
}

class CreateAnswerEvent extends DiscussionEvent {
  final DiscussionItem item;

  CreateAnswerEvent(this.item);
}

class UpdateDiscussionItemEvent extends DiscussionEvent {
  final DiscussionItem item;

  UpdateDiscussionItemEvent(this.item);
}

class DeleteDiscussionItemEvent extends DiscussionEvent {
  final DiscussionItem item;

  DeleteDiscussionItemEvent(this.item);
}

abstract class DiscussionState extends Equatable {
  @override
  List<Object> get props => [];
}

class DiscussionLoadingState extends DiscussionState {}

class DiscussionSnapshotState extends DiscussionState {
  final List<DiscussionItem> items;

  DiscussionSnapshotState(this.items);
}

class DiscussionSuccessState extends DiscussionState {
  final String message;

  DiscussionSuccessState(this.message);
}

class DiscussionFailureState extends DiscussionState {
  final String message;

  DiscussionFailureState(this.message);
}

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final DiscussionService _discussionService;
  StreamSubscription _subscription;

  DiscussionBloc(this._discussionService) : super(DiscussionLoadingState());

  Stream<DiscussionState> _mapStreamToState() async* {
    await _subscription?.cancel();
    _subscription = _discussionService
        .discussionStream()
        .listen((snapshot) => add(DiscussionSnapshotEvent(snapshot)));
  }

  Stream<DiscussionState> _mapSetItemToState(CreateAnswerEvent event) async* {
    try {
      await _discussionService.setAnswer(event.item);
      yield DiscussionSuccessState('Success creating \'${event.item.label}\'');
    } catch (e) {
      yield DiscussionFailureState('Error creating \'${event.item.label}\'');
    }
    add(DiscussionLoadingEvent());
  }

  Stream<DiscussionState> _mapUpdateItemToState(
      UpdateDiscussionItemEvent event) async* {
    try {
      await _discussionService.updateDiscussionItem(event.item);
      yield DiscussionSuccessState('Success updating \'${event.item.label}\'');
    } catch (e) {
      yield DiscussionFailureState('Error updating \'${event.item.label}\'');
    }
    add(DiscussionLoadingEvent());
  }

  Stream<DiscussionState> _mapDeleteItemToState(
      DeleteDiscussionItemEvent event) async* {
    if (!event.item.isEntry) {
      try {
        await _discussionService.deleteDiscussionItem(event.item);
        yield DiscussionSuccessState(
            'Success deleting \'${event.item.label}\'');
      } catch (e) {
        yield DiscussionFailureState('Error deleting  \'${event.item.label}\'');
      }
      add(DiscussionLoadingEvent());
    } else {
      yield DiscussionFailureState('Start of discussions can not be deleted');
    }
  }

  @override
  Stream<DiscussionState> mapEventToState(DiscussionEvent event) async* {
    if (event is DiscussionSnapshotEvent) {
      yield DiscussionSnapshotState(event.items);
    }

    if (event is CreateAnswerEvent) {
      yield* _mapSetItemToState(event);
    }
    if (event is UpdateDiscussionItemEvent) {
      yield* _mapUpdateItemToState(event);
    }
    if (event is DeleteDiscussionItemEvent) {
      yield* _mapDeleteItemToState(event);
    }
    if (event is DiscussionLoadingEvent) {
      yield DiscussionLoadingState();

      yield* _mapStreamToState();
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}

class DiscussionsBloc {
  // global discussions in the app
  // TODO implement
}
