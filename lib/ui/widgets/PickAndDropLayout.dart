import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:uber_lyft_app/utils/Constants.dart';
import 'package:uber_lyft_app/utils/RequestPlace.dart';
import 'package:uber_lyft_app/utils/draw_request_location_icon.dart';

typedef DropLocationListener = void Function(LatLng latLng);
typedef PickupLocationListener = void Function(LatLng latLng);


class PickAndDropLayout extends StatefulWidget {
  DropLocationListener _onDropLocation;
  PickupLocationListener _onPickLocation;

  String pickUpLocationTag = "Pickup Location";
  LatLng pickupLocation;

  PickAndDropLayout(
      @required this.pickupLocation, @required this.pickUpLocationTag,
      {PickupLocationListener onPickLocation,
      DropLocationListener onDropLocation})
      : super() {
    this._onDropLocation = onDropLocation;
    this._onPickLocation = onPickLocation;
  }

  @override
  State<StatefulWidget> createState() {
    return PickAndDropLayoutImp();
  }
}

class PickAndDropLayoutImp extends State<PickAndDropLayout> {
  GoogleMapsPlaces _places;
  String dropLocationTag = "Drop Location";
  LatLng dropLocation;

  @override
  void initState() {
    _places = GoogleMapsPlaces(apiKey: Constants.kGoogleApiKey);
  }

  @override
  Widget build(BuildContext context) {
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
                            widget.pickupLocation = LatLng(lat, lng);
                            widget._onPickLocation(widget.pickupLocation);
                            setState(() {
                              widget.pickUpLocationTag = detail.result.name;
                            });
                          }
                        },
                        child: Text(
                          widget.pickUpLocationTag,
                          style: TextStyle(
                              fontSize: 15.0,
                              height: 1,
                              color: widget.pickUpLocationTag
                                          .compareTo("Pickup Location") ==
                                      0
                                  ? Colors.grey
                                  : Colors.black),
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
                            dropLocation = LatLng(lat, lng);
                            widget._onDropLocation(dropLocation);
                            setState(() {
                              dropLocationTag = detail.result.name;
                            });
                          }
                        },
                        child: Text(
                          dropLocationTag,
                          style: TextStyle(
                              fontSize: 15.0,
                              height: 1,
                              color:
                                  dropLocationTag.compareTo("Drop Location") ==
                                          0
                                      ? Colors.grey
                                      : Colors.black),
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



