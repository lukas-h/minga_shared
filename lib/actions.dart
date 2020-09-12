import 'dart:async';
import 'dart:web_gl';

import 'package:firestore_api/firestore_api.dart';

enum ActionType { create, update, delete }

class ActionResult {
  final ActionType type;
  final DocumentReference selfRef;
  final bool successful;
  final String message;
  final String label;
  ActionResult.success(
    this.selfRef,
    this.label,
    this.type, {
    this.message,
  }) : successful = true;
  ActionResult.failure(
    this.selfRef,
    this.label,
    this.type, {
    this.message,
  }) : successful = false;
}

abstract class DocumentAction<T> with BatchHelper {
  final Firestore firestore;
  DocumentAction(this.firestore);
  Future<ActionResult> runActionInternal(T model);
  Future<ActionResult> runAction(T model) async {
    startBatch(firestore);

    ActionResult result = await runActionInternal(model);

    await finishBatch();
    return result;
  }
}

abstract class DocumentTransaction<T> {
  final Firestore firestore;
  DocumentTransaction(this.firestore);
  Future<ActionResult> runActionInternal(T model, Transaction t);
  Future<ActionResult> runAction(T model) {
    return firestore.runTransaction<ActionResult>(
        (Transaction t) => runActionInternal(model, t));
  }
}

abstract class DocumentQuery<T> {
  final DocumentReference query;

  DocumentQuery(this.query);

  T mapQuery(DocumentSnapshot snapshot);

  Stream<T> get stream => query.snapshots.map((snap) => mapQuery(snap));

  Future<T> get document async => mapQuery(await query.document);

  Future<bool> get exists async => (await query.document).exists;
}

abstract class DocumentQueryHolder<T> {
  final DocumentReference query;

  T holder;

  StreamSubscription<DocumentSnapshot> _subscription;

  DocumentQueryHolder(this.query);

  T mapDocument(DocumentSnapshot snapshot);

  _updateDocuments(DocumentSnapshot snapshot) {
    holder = mapDocument(snapshot);
  }

  void listen() {
    _subscription = query.snapshots.listen(_updateDocuments);
  }

  void cancel() {
    _subscription?.cancel();
  }

  get document => holder;
}

abstract class CollectionQuery<T> {
  final Query query;

  CollectionQuery(this.query);

  List<T> mapQuery(List<DocumentSnapshot> snapshots);

  Stream<List<T>> get stream =>
      query.snapshots().map<List<T>>((snap) => mapQuery(snap?.documents));
  Future<List<T>> get documents async =>
      mapQuery((await query.getDocuments())?.documents);
}

abstract class CollectionHolder<T> implements Iterable<T> {
  void add(T);
  void modify(T);
  void remove(T);
  T operator [](int index);
}

abstract class CollectionQueryHolder<T> {
  final Query query;
  final CollectionHolder<T> holder;
  StreamSubscription<QuerySnapshot> _subscription;

  CollectionQueryHolder(this.query, this.holder);

  T mapDocument(DocumentSnapshot snapshot);

  _updateDocuments(QuerySnapshot snapshot) {
    for (DocumentChange change in snapshot.documentChanges) {
      switch (change.type) {
        case DocumentChangeType.added:
          holder.add(change.document);
          break;
        case DocumentChangeType.modified:
          break;
        case DocumentChangeType.removed:
          break;
      }
    }
  }

  void listen() {
    _subscription = query.snapshots().listen(_updateDocuments);
  }

  void cancel() {
    _subscription?.cancel();
  }

  CollectionHolder<T> get documents => holder;
}
