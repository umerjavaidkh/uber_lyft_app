import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_lyft_app/ui/states/HomePageState.dart';
import 'package:uber_lyft_app/ui/widgets/GoogleMapWidget.dart';
import 'package:uber_lyft_app/ui/widgets/RequestCabButton.dart';
import '../NetworkService.dart';
import 'MapsPresenter.dart';
import 'MapsView.dart';
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

  HomePageState _homePageState = HomePageState();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _homePageState.mapsPresenter = MapsPresenter(NetworkService());
    _homePageState.mapsPresenter.onAttach(this);

  }

  void _getUserLocation() async {
    Position position = await _homePageState.locationService.provideCurrentLocation();
    setState(() {
      _homePageState.center = LatLng(position.latitude, position.longitude);
    });
  }

  void _getUserLocationName(LatLng latLng) async {
    Placemark position = await _homePageState.locationService.getAddressFromLocation(
        latLng.latitude, latLng.longitude);
    setState(() {
      _homePageState.pickupLocation =
          LatLng(position.position.latitude, position.position.longitude);
      _homePageState.pickUpLocationTag = position.name + ", " + position.administrativeArea;
    });
  }

  void _onMapCreated(GoogleMapWidgetOBJ self) {
    _homePageState.googleMapWidgetObj=self;
    _homePageState.mapLoading = false;
    _getUserLocationName(_homePageState.center);
    _homePageState.mapsPresenter.showNearbyCabs(_homePageState.center);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            if (_homePageState.center != null)
              AnimatedOpacity(
                opacity: _homePageState.mapLoading ? 0 : 1,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 1000),
                child: Container(
                  color: Colors.white24,
                  child: GoogleMapWidget( _homePageState.center,
                    onMapCreatedListener: (GoogleMapWidgetOBJ self){
                      _onMapCreated(self);
                    },
                    confirmTripVisibility: (){
                      setState(() {
                        _homePageState.confirmTripVisibility = true;
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
            if (!_homePageState.requestCabClicked)
              PickAndDropLayout(
                _homePageState.pickupLocation,
                _homePageState.pickUpLocationTag,
                onPickLocation: (LatLng latlng) {
                  _homePageState.pickupLocation = latlng;
                },
                onDropLocation: (LatLng latln) {
                  setState(() {
                    _homePageState.dropLocation = latln;
                  });
                },
              ),
            if (_homePageState.dropLocation != null && !_homePageState.requestCabClicked)
              //_requestCabButton(),

              RequestButton("Request Cab", onTap: () {
                setState(() {
                  _homePageState.requestCabClicked = true;
                });
                _homePageState.mapsPresenter.requestCab(_homePageState.pickupLocation, _homePageState.dropLocation);
              }),

            if (_homePageState.confirmTripVisibility)
              RequestButton("Confirm Trip", onTap: () {
                setState(() {
                  _homePageState.confirmTripVisibility = false;
                });

                _homePageState.mapsPresenter.confirmPickup(_homePageState.pickupLocation, _homePageState.dropLocation);
              }),

            if (_homePageState.onCabArrivedVisibility)
              RequestButton("START Trip", onTap: () {
                setState(() {
                  _homePageState.onCabArrivedVisibility = false;
                });
                _homePageState.googleMapWidgetObj.clearMap();
                _homePageState.mapsPresenter.onStartTrip(_homePageState.pickupLocation, _homePageState.dropLocation);
              })
          ],
        ));
  }

  @override
  informCabArrived() {

    setState(() {
      _homePageState.onCabArrivedVisibility = true;
    });

  }

  @override
  informTripEnd() {

  }


  @override
  showDirectionApiFailedError(String error) {
    // TODO: implement showDirectionApiFailedError
    throw UnimplementedError();
  }

  @override
  showNearbyCabs(List<LatLng> latLngList) {

    _homePageState.googleMapWidgetObj.showNearbyCabs(latLngList);
  }

  @override
  showPath(List<LatLng> latLngList) async {

    _homePageState.googleMapWidgetObj.showPath(latLngList);

  }

  @override
  showRoutesNotAvailableError() {
    // TODO: implement showRoutesNotAvailableError
    throw UnimplementedError();
  }

  @override
  updateCabLocation(LatLng latLng) {

    _homePageState.googleMapWidgetObj.updateCabLocation(latLng);
  }

  @override
  showPathDest(List<LatLng> latLngList) {

    _homePageState.googleMapWidgetObj.showDestinationPath(latLngList);
  }

  @override
  updateCabLocationDest(LatLng latLng) {

    _homePageState.googleMapWidgetObj.updateDestCabLocation(latLng);
  }
}
