

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_lyft_app/ui/widgets/GoogleMapWidget.dart';
import 'package:uber_lyft_app/utils/LocationProvider.dart';

import '../MapsPresenter.dart';
import '../../main.dart';

class HomePageState{


  final locationService = getIt.get<LocationProvider>();

  LatLng center =null;

  LatLng pickupLocation;

  LatLng dropLocation;

  String pickUpLocationTag = "Pickup Location";

  String dropLocationTag = "Drop Location";

  bool mapLoading = true;

  bool requestCabClicked = false;

  bool confirmTripVisibility = false;

  bool onCabArrivedVisibility = false;

  MapsPresenter mapsPresenter;

  GoogleMapWidgetOBJ googleMapWidgetObj;

}