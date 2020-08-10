import 'package:firestore_api/firestore_api.dart';
import 'package:minga_shared/user/user_model.dart';

class DonationTest {
  final Firestore firestore;
  DocumentReference donorRef, collectorRef, centerAdminRef;

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
  }

  Future<void> tearDown() async {}
}
