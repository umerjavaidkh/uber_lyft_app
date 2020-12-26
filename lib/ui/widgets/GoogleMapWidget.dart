
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_lyft_app/utils/AnimateMarker.dart';
import 'package:uber_lyft_app/utils/AnimatePolyLine.dart';
import 'package:uber_lyft_app/utils/IconsUtils.dart';
import 'package:uber_lyft_app/utils/LocationProvider.dart';
import 'package:uber_lyft_app/utils/MapUtils.dart';

import '../../main.dart';



typedef OnMapCreatedListener = void Function(GoogleMapWidgetOBJ self);
typedef ConfirmTripVisibility = void Function( );


class  GoogleMapWidget extends StatefulWidget{


  LatLng center = null;

  OnMapCreatedListener onMapCreatedListener;
  ConfirmTripVisibility confirmTripVisibility;

  GoogleMapWidget(
       LatLng currentLocation,
      {OnMapCreatedListener onMapCreatedListener ,ConfirmTripVisibility confirmTripVisibility})
      : super() {
    this.onMapCreatedListener = onMapCreatedListener;
    this.confirmTripVisibility = confirmTripVisibility;
    this.center = currentLocation;
  }

  @override
  State<StatefulWidget> createState() {

    return GoogleMapWidgetOBJ();
  }
}


class GoogleMapWidgetOBJ extends State<GoogleMapWidget>{

  String _mapStyle;

  final locationService = getIt.get<LocationProvider>();

  List<Marker> nearByCabMarkers = List<Marker>();

  Set<Polyline> cabToPickUpLine = {};

  GoogleMapController _controller;

  BitmapDescriptor cabIcon = BitmapDescriptor.defaultMarker;

  void _onMapCreated(GoogleMapController mycontroller) {
    _controller=mycontroller;
    _controller.setMapStyle(_mapStyle);
    widget.onMapCreatedListener(this);
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    getCabIcon();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: widget.center,
        zoom: 15.0,
      ),
      markers: nearByCabMarkers.toSet(),
      polylines: cabToPickUpLine,
      mapType: MapType.normal,
    );
  }

  void getCabIcon() async {
    cabIcon = await IconUtils.createMarkerImageFromAsset();
  }

  showNearbyCabs(List<LatLng> latLngList) {
    int count = 0;
    for (LatLng item in latLngList) {
      nearByCabMarkers.add(Marker(
          markerId: MarkerId(count.toString()), icon: cabIcon, position: item));
      count++;
    }

    setState(() {});
  }

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
        widget.confirmTripVisibility();
      },

      onUpdate: (){
        setState(() {
          // update cabToPickUpLine on map
        });
      },

    ).animateMe();

    MapUtils.setMapFitToPolyLine(cabToPickUpLine, _controller);
  }

  showDestinationPath(List<LatLng> latLngList) async {
    setState(() {
      nearByCabMarkers.clear();
      nearByCabMarkers.add(Marker(
          anchor: Offset(0.5, 0.5),
          markerId: MarkerId("1233"),
          icon: cabIcon,
          position: latLngList[0]));
      nearByCabMarkers.add(Marker(
          markerId: MarkerId("1244"),
          position: latLngList[latLngList.length - 1]));
    });

    AnimatePolyLine(
      latLngList,
      cabToPickUpLine,
      Colors.green,
      onFinish: () {

      },

      onUpdate: (){
        setState(() {
          // update cabToPickUpLine on map
        });
      },

    ).animateMe();

    MapUtils.setMapFitToPolyLine(cabToPickUpLine, _controller);
  }


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


  clearMap(){

    setState(() {

      nearByCabMarkers.clear();
      cabToPickUpLine.clear();

    });

  }


  updateDestCabLocation(LatLng latLng) {
    int cabMarkerIndex = nearByCabMarkers
        .indexWhere((element) => element.markerId.value == "1233");

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

}