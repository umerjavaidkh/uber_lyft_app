import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider {

  int distance;

  LocationAccuracy locationAccuracy;

  LocationProvider({this.locationAccuracy=LocationAccuracy.high,this.distance=10});

  Future<Position> provideLastKnownLocation() async {
    return await Geolocator()
        .getLastKnownPosition(desiredAccuracy: locationAccuracy);
  }

  Future<Position> provideCurrentLocation() async {
    Position _position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: locationAccuracy);

    if (_position == null) {
      _position = await provideLastKnownLocation();
    }
    return _position;
  }


  provideLocationStream(Function listener) {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: locationAccuracy, distanceFilter: distance);

    //StreamSubscription<Position> positionStream =
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      if (position != null) listener(position);
    });

    /*var myResult = "";
    mySlowMethod((result) {
      myResult = result;
      print(myResult);
    });*/
  }

  Future<bool> checkForLocationPermission() async {
    GeolocationStatus geolocationStatus =
        await Geolocator().checkGeolocationPermissionStatus();
    if (geolocationStatus.value == GeolocationStatus.granted.value) return true;
    return false;
  }

  Future<Placemark> getLocationFromAddress(String address) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromAddress(address);
    if (placemark != null && !placemark.isEmpty) return placemark.removeLast();
    return null;
  }

  Future<Placemark> getAddressFromLocation(double lat, double lon) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(lat, lon);
    if (placemark != null && !placemark.isEmpty) return placemark.removeLast();
    return null;
  }
}
