import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lazy_evaluation/lazy_evaluation.dart';
import 'package:uber_lyft_app/utils/LocationProvider.dart';
import 'package:uber_lyft_app/utils/RequestPlace.dart';
import 'package:uber_lyft_app/utils/draw_request_location_icon.dart';


const kGoogleApiKey = "your_key_here";

// This is our global ServiceLocator
GetIt getIt = GetIt.instance;

void main() {
  getIt.registerSingleton( LocationProvider());
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uber Lyft App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();

  final locationService = getIt.get<LocationProvider>();

  LatLng center = null;

  LatLng  pickupLocation;

  LatLng  dropLocation;

  String _mapStyle;

  String pickUpLocationTag = "Pickup Location";

  String dropLocationTag = "Drop Location";




  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });

    _getUserLocation();
  }


  void _getUserLocation() async {
    Position position = await locationService.provideCurrentLocation();
    setState(() {
      center = LatLng(position.latitude, position.longitude);
     /*if(_controller.isCompleted){
       _controller.future.then((value) => value.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
         target: center,
         zoom: 11.0,
       ))));*/
     //}
    });
  }

  void _getUserLocationName(LatLng latLng) async {

    Placemark position = await locationService.getAddressFromLocation(latLng.latitude, latLng.longitude);
    setState(() {
      pickupLocation=LatLng(position.position.longitude, position.position.longitude);
      pickUpLocationTag=position.name+", "+position.administrativeArea;
    });
  }



  void _onMapCreated(GoogleMapController mycontroller) {
    _controller.complete(mycontroller);
    mycontroller.setMapStyle(_mapStyle);
    _getUserLocationName(center);
  }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(

          children: <Widget>[

            if(center!=null)
            Container(
              color: Colors.white24,

              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 15.0,
                ),
              ),
            )

            else Container(
              color: Color(0x588ca4),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
            )
            ,
            pickAndDropLayout(),
          ],
        ));
  }

  Container pickAndDropLayout() {

    GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

    return Container(
      height: 100,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 100.0, left: 20, right: 20),
      //padding: EdgeInsets.all(2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 100,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: 27),
            child: CustomPaint(
                painter: ReqLocIcon(
                    radius: 5.0, color: Colors.black, lineHeight: 35)),
          ),
          Container(
            margin: EdgeInsets.only(right: 5),
            height: 100,
            width: MediaQuery.of(context).size.width - 100,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(6),
                    color: Color(0xfff3f3f4),
                    margin: EdgeInsets.all(5),
                    child: Material(
                      color: Colors.white.withOpacity(0.0),
                      child: InkWell(
                        onTap: () async {
                          Prediction p = await getPaceOverlay(context);
                          if (p != null) {
                            PlacesDetailsResponse detail =
                                await _places.getDetailsByPlaceId(p.placeId);
                            final lat = detail.result.geometry.location.lat;
                            final lng = detail.result.geometry.location.lng;
                            pickupLocation=LatLng(lat, lng);
                            setState(() {
                              pickUpLocationTag = detail.result.name;
                            });
                          }
                        },
                        child: Text(
                          pickUpLocationTag,
                          style: TextStyle(
                              fontSize: 15.0, height: 1, color: Colors.grey),
                        ),
                      ),
                    )),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(6),
                    color: Color(0xfff3f3f4),
                    margin: EdgeInsets.all(5),
                    child: Material(
                      color: Colors.white.withOpacity(0.0),
                      child: InkWell(
                        onTap: () async {
                          Prediction p = await getPaceOverlay(context);
                          if (p != null) {
                            PlacesDetailsResponse detail =
                                await _places.getDetailsByPlaceId(p.placeId);
                            final lat = detail.result.geometry.location.lat;
                            final lng = detail.result.geometry.location.lng;
                            dropLocation=LatLng(lat,lng);
                            setState(() {
                              dropLocationTag = detail.result.name;
                            });
                          }
                        },
                        child: Text(
                          dropLocationTag,
                          style: TextStyle(
                              fontSize: 15.0, height: 1, color: Colors.grey),
                        ),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }


}
