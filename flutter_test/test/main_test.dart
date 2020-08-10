import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firestore_flutter/firestore_flutter.dart';
import 'package:test/test.dart';

import 'donation_test.dart';

Future<void> main() async {
  var _donationTest =
      DonationTest(FirestoreImpl.fromInstance(MockFirestoreInstance()));
  group('donation test', () {
    setUp(() async {
      await _donationTest.setUp();
    });
    test('intialized', () {
      expect(_donationTest != null, true);
    });
    test('Step 1: create Donation', _donationTest.step1());
    test('Step 2: assign Center', _donationTest.step2());
    test('Step 3 needs Service', _donationTest.step3());
    test('Step 4 Service staffed', _donationTest.step4());
    test('Step 5 picked up', _donationTest.step5());
    test('Step 6 delivered', _donationTest.step6());
    test('Step 7 delivery verifiedw', _donationTest.step7());

    tearDown(() async {
      await _donationTest.tearDown();
    });
  });
}
