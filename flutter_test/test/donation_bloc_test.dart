import 'package:test/test.dart';

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

main(List<String> args) {
  var auth1 = MockFirebaseAuth(signedIn: true);
  var auth2 = MockFirebaseAuth(signedIn: true);
  var auth3 = MockFirebaseAuth(signedIn: true);
  setUp(() {
    auth1.currentUser().then(print);
    auth2.currentUser().then(print);
    auth3.currentUser().then(print);
  });
  tearDown(() {});
}
