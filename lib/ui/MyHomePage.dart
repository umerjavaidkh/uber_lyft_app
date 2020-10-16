import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_lyft_app/ui/widgets/RequestCabButton.dart';
import 'package:uber_lyft_app/utils/AnimateMarker.dart';
import 'package:uber_lyft_app/utils/AnimatePolyLine.dart';
import 'package:uber_lyft_app/utils/IconsUtils.dart';
import 'package:uber_lyft_app/utils/LocationProvider.dart';
import 'package:uber_lyft_app/utils/MapUtils.dart';

import '../NetworkService.dart';
import 'MapsPresenter.dart';
import 'MapsView.dart';
import 'main.dart';
import 'widgets/PickAndDropLayout.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin
    implements MapsView {
  GoogleMapController _controller;

  final locationService = getIt.get<LocationProvider>();

  LatLng center = null;

  LatLng pickupLocation;

  LatLng dropLocation;

  String _mapStyle;

  String pickUpLocationTag = "Pickup Location";

  String dropLocationTag = "Drop Location";

  bool mapLoading = true;

  bool requestCabClicked = false;

  bool confirmTripVisibility = false;

  MapsPresenter mapsPresenter;

  List<Marker> nearByCabMarkers = List<Marker>();

  Marker originMarker;

  Marker destinationMarker;

  Set<Polyline> cabToPickUpLine = {};

  BitmapDescriptor cabIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    mapsPresenter = MapsPresenter(NetworkService());
    mapsPresenter.onAttach(this);
    _getUserLocation();
    getCabIcon();
  }

  void _getUserLocation() async {
    Position position = await locationService.provideCurrentLocation();
    setState(() {
      center = LatLng(position.latitude, position.longitude);
    });
  }

  void _getUserLocationName(LatLng latLng) async {
    Placemark position = await locationService.getAddressFromLocation(
        latLng.latitude, latLng.longitude);
    setState(() {
      pickupLocation =
          LatLng(position.position.latitude, position.position.longitude);
      pickUpLocationTag = position.name + ", " + position.administrativeArea;
    });
  }

  void getCabIcon() async {
    cabIcon = await IconUtils.createMarkerImageFromAsset();
  }

  void _onMapCreated(GoogleMapController mycontroller) {
    _controller = mycontroller;
    mycontroller.setMapStyle(_mapStyle);
    mapLoading = false;
    _getUserLocationName(center);
    mapsPresenter.showNearbyCabs(center);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            if (center != null)
              AnimatedOpacity(
                opacity: mapLoading ? 0 : 1,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 1000),
                child: Container(
                  color: Colors.white24,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: center,
                      zoom: 15.0,
                    ),
                    markers: nearByCabMarkers.toSet(),
                    polylines: cabToPickUpLine,
                    mapType: MapType.normal,
                  ),
                ),
              )
            else
              Container(
                color: Color(0x588ca4),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            //if (!requestCabClicked) pickAndDropLayout(),
            if (!requestCabClicked)
              PickAndDropLayout(
                pickupLocation,
                pickUpLocationTag,
                onPickLocation: (LatLng latlng) {
                  pickupLocation = latlng;
                },
                onDropLocation: (LatLng latln) {
                  setState(() {
                    dropLocation = latln;
                  });
                },
              ),
            if (dropLocation != null && !requestCabClicked)
              //_requestCabButton(),

              RequestButton("Request Cab", onTap: () {
                setState(() {
                  requestCabClicked = true;
                });
                mapsPresenter.requestCab(pickupLocation, dropLocation);
              }),

            if (confirmTripVisibility)
              RequestButton("Confirm Trip", onTap: () {
                setState(() {
                  confirmTripVisibility = false;
                });

                mapsPresenter.confirmPickup(pickupLocation, dropLocation);
              })
          ],
        ));
  }

  @override
  informCabArrived() {
    // TODO: implement informCabArrived
    throw UnimplementedError();
  }

  @override
  informCabBooked() {
    // TODO: implement informCabBooked
    throw UnimplementedError();
  }

  @override
  informTripEnd() {
    // TODO: implement informTripEnd
    throw UnimplementedError();
  }

  @override
  informTripStart() {
    // TODO: implement informTripStart
    throw UnimplementedError();
  }

  @override
  showDirectionApiFailedError(String error) {
    // TODO: implement showDirectionApiFailedError
    throw UnimplementedError();
  }

  @override
  showNearbyCabs(List<LatLng> latLngList) {
    int count = 0;
    for (LatLng item in latLngList) {
      nearByCabMarkers.add(Marker(
          markerId: MarkerId(count.toString()), icon: cabIcon, position: item));
      count++;
    }

    setState(() {});
  }



  @override
  showPath(List<LatLng> latLngList) async {


    setState(() {
      nearByCabMarkers.clear();
      nearByCabMarkers.add(Marker(
          anchor: Offset(0.5, 0.5),
          markerId: MarkerId("123"),
          icon: cabIcon,
          position: latLngList[0]));
      nearByCabMarkers.add(Marker(
          markerId: MarkerId("124"),
          position: latLngList[latLngList.length - 1]));
    });

    AnimatePolyLine(
      latLngList,
      cabToPickUpLine,
      Colors.red,
      onFinish: () {
        confirmTripVisibility = true;
      },
      onUpdate: (){
        setState(() {
          // update cabToPickUpLine on map
        });
      },

    ).animateMe();

    MapUtils.setMapFitToPolyLine(cabToPickUpLine, _controller);
  }

  @override
  showRoutesNotAvailableError() {
    // TODO: implement showRoutesNotAvailableError
    throw UnimplementedError();
  }

  @override
  updateCabLocation(LatLng latLng) {
    int cabMarkerIndex = nearByCabMarkers
        .indexWhere((element) => element.markerId.value == "123");

    Marker marker = nearByCabMarkers[cabMarkerIndex];

    setState(() {
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: marker.position,
          tilt: 30.0,
          zoom: 17.0,
        ),
      ));
    });

    AnimateMarker(onMarkerPosUpdate: (Marker marker) {
      setState(() {
        nearByCabMarkers[cabMarkerIndex] = marker;
      });
    }).animaterMarker(marker.position, latLng, marker);
  }

  @override
  updateCabLocationDest(LatLng latLng) {
    // TODO: implement updateCabLocationDest
    throw UnimplementedError();
  }

  @override
  showPathDest(List<LatLng> latLngList) {
    // TODO: implement showPathDest
    throw UnimplementedError();
  }
}
