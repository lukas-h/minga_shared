import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firestore_flutter/firestore_flutter.dart';
import 'package:test/test.dart';

import 'donation_test.dart';

Future<void> main() async {
  DonationTest _donationTest;
  setUp(() async {
    _donationTest =
        DonationTest(FirestoreImpl.fromInstance(MockFirestoreInstance()));
    await _donationTest.setUp();
  });

  group('donation test', () {
    test('test', () {
      expect(true, true);
    });
  });

  tearDown(() async {
    await _donationTest.tearDown();
  });
}
