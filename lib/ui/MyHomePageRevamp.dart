import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_lyft_app/ui/widgets/GoogleMapWidget.dart';
import 'package:uber_lyft_app/ui/widgets/RequestCabButton.dart';
import 'package:uber_lyft_app/utils/LocationProvider.dart';


import '../NetworkService.dart';
import 'MapsPresenter.dart';
import 'MapsView.dart';
import 'main.dart';
import 'widgets/PickAndDropLayout.dart';

class MyHomePageRevamp extends StatefulWidget {
  MyHomePageRevamp({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePageRevamp>
    with SingleTickerProviderStateMixin
    implements MapsView {


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

  GoogleMapWidgetOBJ _googleMapWidgetObj;

  @override
  void initState() {
    super.initState();


    _getUserLocation();

    mapsPresenter = MapsPresenter(NetworkService());
    mapsPresenter.onAttach(this);

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



  void _onMapCreated(GoogleMapWidgetOBJ self) {
    _googleMapWidgetObj=self;
    mapLoading = false;
    _getUserLocationName(center);
    mapsPresenter.requestNearbyCabs(center);
    
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
                  child: GoogleMapWidget( center,
                    onMapCreatedListener: (GoogleMapWidgetOBJ self){
                      _onMapCreated(self);
                    },
                    confirmTripVisibility: (){
                      setState(() {
                         confirmTripVisibility = true;
                      });

                    },
                  )

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
              }),

            if (onCabArrivedVisibility)
              RequestButton("START Trip", onTap: () {
                setState(() {
                  onCabArrivedVisibility = false;
                });
                _googleMapWidgetObj.clearMap();
                mapsPresenter.onStartTrip(pickupLocation, dropLocation);
              })
          ],
        ));
  }

  @override
  informCabArrived() {

    setState(() {
      onCabArrivedVisibility = true;
    });

  }

  @override
  informCabBooked() {
    // TODO: implement informCabBooked
    throw UnimplementedError();
  }

  @override
  informTripEnd() {



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
    
    _googleMapWidgetObj.showNearbyCabs(latLngList);
  }

  @override
  showPath(List<LatLng> latLngList) async {

    _googleMapWidgetObj.showPath(latLngList);

  }

  @override
  showRoutesNotAvailableError() {
    // TODO: implement showRoutesNotAvailableError
    throw UnimplementedError();
  }

  @override
  updateCabLocation(LatLng latLng) {

    _googleMapWidgetObj.updateCabLocation(latLng);
  }

  @override
  showPathDest(List<LatLng> latLngList) {

    _googleMapWidgetObj.showDestinationPath(latLngList);
  }


  @override
  updateCabLocationDest(LatLng latLng) {

    _googleMapWidgetObj.updateDestCabLocation(latLng);
  }


}
