import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:minga_shared/donation/donation_bloc.dart';
import 'package:test/test.dart';

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

main(List<String> args) async {
  var auth1 = MockFirebaseAuth(signedIn: true);
  var user1 = await auth1.currentUser();
  var auth2 = MockFirebaseAuth(signedIn: true);
  var user2 = await auth2.currentUser();
  var auth3 = MockFirebaseAuth(signedIn: true);
  var user3 = await auth3.currentUser();
  setUp(() {});
  var firestore = MockFirestoreInstance();
  tearDown(() {});
}
