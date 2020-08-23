
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class  MapUtils{


  static void setMapFitToPolyLine(Set<Polyline> p,GoogleMapController googleMapController) {
    double minLat = p.first.points.first.latitude;
    double minLong = p.first.points.first.longitude;
    double maxLat = p.first.points.first.latitude;
    double maxLong = p.first.points.first.longitude;
    p.forEach((poly) {
      poly.points.forEach((point) {
        if(point.latitude < minLat) minLat = point.latitude;
        if(point.latitude > maxLat) maxLat = point.latitude;
        if(point.longitude < minLong) minLong = point.longitude;
        if(point.longitude > maxLong) maxLong = point.longitude;
      });
    });
    googleMapController.moveCamera(CameraUpdate.newLatLngBounds(LatLngBounds(
        southwest: LatLng(minLat, minLong),
        northeast: LatLng(maxLat,maxLong)
    ), 20));
  }

  static num radsToDegrees(num rad) {
    return (rad * 180.0) / pi;
  }

  static num getRotation(LatLng start, LatLng end) {
  double latDifference    = (start.latitude - end.latitude).abs();
  double lngDifference    = (start.longitude - end.longitude).abs();
  num rotation = -1;

  if(start.latitude < end.latitude && start.longitude < end.longitude) {
  rotation = radsToDegrees(atan(lngDifference / latDifference)).toDouble();
  }
  else if (start.latitude >= end.latitude && start.longitude < end.longitude) {
  rotation = (90 - radsToDegrees(atan(lngDifference / latDifference)) + 90).toDouble();
  }
  else if(start.latitude >= end.latitude && start.longitude >= end.longitude) {
  rotation = (radsToDegrees(atan(lngDifference / latDifference)) + 180).toDouble();
  }
  else if (start.latitude < end.latitude && start.longitude >= end.longitude) {
  rotation =
  (90 - radsToDegrees(atan(lngDifference / latDifference)) + 270).toDouble();
  }

  return rotation;
}



}