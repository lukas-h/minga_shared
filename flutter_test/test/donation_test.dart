import 'package:firestore_api/firestore_api.dart';
import 'package:minga_shared/donation/donation_bloc.dart';
import 'package:minga_shared/donation/donation_model.dart';
import 'package:minga_shared/donation/donation_service.dart';
import 'package:minga_shared/minga_shared.dart';
import 'package:minga_shared/user/user_model.dart';

class DonationTest {
  final Firestore firestore;
  DocumentReference donorRef, collectorRef, centerAdminRef;
  ProductClass productClass;
  Donation donation;
  DonationBloc bloc;

  DonationTest(this.firestore);

  Future<void> setUp() async {
    donorRef = await firestore.collection('users').add(
          MingaUser(
                  email: 'donor@minga-app.org',
                  firstName: 'Donor',
                  lastName: 'User',
                  phone: '+56 XXX XXXX XXXX')
              .toMap(),
        );
    collectorRef = await firestore.collection('users').add(
          MingaUser(
                  email: 'collectr@minga-app.org',
                  firstName: 'Collector',
                  lastName: 'User',
                  phone: '+56 XXX XXXX XXXX')
              .toMap(),
        );
    centerAdminRef = await firestore.collection('users').add(
          MingaUser(
                  email: 'test@minga-app.org',
                  firstName: 'Center Admin',
                  lastName: 'User',
                  phone: '+56 XXX XXXX XXXX')
              .toMap(),
        );

    productClass = ProductClass(
      selfRef: firestore.collection('productClasses').document(),
      label: 'Bananas',
      averagePriceInCLPeso: 300,
      unit: 'kg',
      quantity: 1,
      conditions: [
        ProductCondition(
          label: 'fresh',
          durationToExpiry: 24 * 3,
        ),
      ],
      sizes: null,
      maximumDelayForPickup: 24,
    );

    await productClass.selfRef.setData(productClass.toMap());

    donation = Donation.fromProductClass(
      productClass,
      donorRef,
      DateTime.now().add(Duration(days: 1)),
      selfRef: firestore.collection('donations').document(),
      label: 'Bananas',
      size: ProductSize(from: 4, to: 4, unit: 'kg'),
      condition: ProductCondition(
        label: 'soon expired',
        durationToExpiry: 24,
      ),
    );

    await donation.selfRef.setData(donation.toMap());

    bloc = DonationBloc(DonationService(firestore, donation));
  }

  Function step1() {
    return () async {};
  }

  Function step2() {
    return () async {};
  }

  Function step3() {
    return () async {};
  }

  Function step4() {
    return () async {};
  }

  Function step5() {
    return () async {};
  }

  Function step6() {
    return () async {};
  }

  Function step7() {
    return () async {};
  }

  Future<void> tearDown() async {}
}
