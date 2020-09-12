import '../donation/donation_model.dart';
import 'package:turf/distance.dart';
import 'package:turf/helpers.dart';

class CompensationCalculator {
  static num calculateDelivery(DonationModel donationModel) {
    var startPoint =
        Feature<Point>.fromJson(donationModel.startLocation).geometry;
    var endPoint =
        Feature<Point>.fromJson(donationModel.startLocation).geometry;
    num dist = distance(startPoint, endPoint, Unit.kilometers);
    return (dist > 3) ? 30 : 16;
  }
}
