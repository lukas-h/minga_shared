import 'package:mapbox_search/mapbox_search.dart';
import '../credentials.dart';
import 'package:turf/turf.dart';

import '../helpers.dart';

class PositionService {
  final StaticImage _staticImage;
  PositionService() : _staticImage = StaticImage(apiKey: MAPBOX_KEY);

  String getDirectionsImage(
    Point start,
    Point end, {
    int height = 100,
    int width = 500,
  }) =>
      _staticImage.getStaticUrlWithPolyline(
        bearing: 180,
        point1: start.coordinates,
        point2: end.coordinates,
        marker1: MapBoxMarker(
            markerColor: Colors.primary200,
            markerLetter: 'd',
            markerSize: MarkerSize.MEDIUM),
        marker2: MapBoxMarker(
            markerColor: Colors.primary200,
            markerLetter: 'c',
            markerSize: MarkerSize.SMALL),
        height: height,
        width: width,
        zoomLevel: 14,
        style: MapBoxStyle.Streets,
        render2x: true,
        center: midpoint(start, end).coordinates,
      );
  String getPointImage(
    Point point, {
    int height = 100,
    int width = 500,
  }) =>
      StaticImage(apiKey: MAPBOX_KEY).getStaticUrlWithMarker(
        center: point.coordinates,
        style: MapBoxStyle.Streets,
        zoomLevel: 11,
        height: 100,
        render2x: true,
        width: 500,
        marker: MapBoxMarker(
          markerLetter: 'o',
          markerSize: MarkerSize.LARGE,
          markerColor: Colors.primary200,
        ),
      );
}
