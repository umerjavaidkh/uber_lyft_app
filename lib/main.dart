import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:uber_lyft_app/utils/draw_circle.dart';
import 'package:uber_lyft_app/utils/draw_request_location_icon.dart';
import 'package:uber_lyft_app/utils/styles.dart';

void main() {
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

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  String _mapStyle;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  void _onMapCreated(GoogleMapController mycontroller) {
    _controller.complete(mycontroller);

    mycontroller.setMapStyle(_mapStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        pickAndDropLayout(),
      ],
    ));
  }

  Container pickAndDropLayout() {
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
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 27),
                  child: CustomPaint(
                      painter: ReqLocIcon(
                          radius: 5.0, color: Colors.black, lineHeight: 40)),
                ),
              ],
            ),
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
                        onTap: () {
                          print("Hello world");
                        },
                        child: Text(
                          "Pickup Location",
                          style: TextStyle(
                              fontSize: 15.0, height: 1, color: Colors.grey),
                        ),
                      ),
                    )
                    ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(6),
                  color: Color(0xfff3f3f4),
                  margin: EdgeInsets.all(5),
                  child: Material(
                    color: Colors.white.withOpacity(0.0),
                    child: InkWell(
                      onTap: () {
                        print("Hello world");
                      },
                      child: Text(
                        "Drop Location",
                        style: TextStyle(
                            fontSize: 15.0, height: 1, color: Colors.grey),
                      ),
                    ),
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
