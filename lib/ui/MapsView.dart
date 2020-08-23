import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapsView {

 showNearbyCabs(List<LatLng> latLngList);

 informCabBooked();

 showPath(List<LatLng> latLngList);

 updateCabLocation(LatLng latLng);

 informCabIsArriving();

 informCabArrived();

 informTripStart();

 informTripEnd();

 showRoutesNotAvailableError();

 showDirectionApiFailedError(String error);

}