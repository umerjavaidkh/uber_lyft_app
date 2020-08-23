
import 'dart:convert';
import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart' as PolyLineLib;
import 'package:google_directions_api/google_directions_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_lyft_app/utils/Constants.dart';

import 'JsonMessage.dart';
import 'WebSocketListener.dart';

class Simulator{


    LatLng currentLocation;

   /* LatLng pickUpLocation;

    LatLng dropUpLocation;*/

    var pickUpPath = List<LatLng>();


    static getFakeNearByCabs(LatLng userLoc,WebSocketListener webSocketListener){

    var size = Random().nextInt(6);

    List nearByCabs= List<LatLng>();

    JsonMessage jsonMessage=JsonMessage();
    jsonMessage.tag=Constants.nearByCabs;

    for (int  i=0; i<=size; i++) {

      var randomOperatorForLat = Random().nextInt(1);
      var randomOperatorForLng = Random(1).nextInt(1);

      var randomDeltaForLat = ((10+Random().nextInt(40)) /10000.00).toDouble();
      var randomDeltaForLng = ((10+Random().nextInt(40)) /10000.00).toDouble();

      if (randomOperatorForLat == 1) {
        randomDeltaForLat *= -1;
      }
      if (randomOperatorForLng == 1) {
        randomDeltaForLng *= -1;
      }
      var randomLatitude =  userLoc.latitude + randomDeltaForLat; //max((userLoc.latitude + randomDeltaForLat),90.00);
      var randomLongitude = userLoc.longitude + randomDeltaForLng;//max((userLoc.longitude + randomDeltaForLng),180.00);

      nearByCabs.add(LatLng(randomLatitude,randomLongitude));
    }

    jsonMessage.data=nearByCabs;

    var jsonObjectToPush = jsonEncode(jsonMessage);

    webSocketListener.onMessage(jsonObjectToPush);

  }



    requestCab( LatLng pickUpLocation, LatLng dropLocation, WebSocketListener webSocketListener) {


       /* this.pickUpLocation=pickUpLocation;
        this.dropUpLocation=dropLocation;*/

        var randomOperatorForLat = Random().nextInt(1);
        var randomOperatorForLng = Random(1).nextInt(1);

        var randomDeltaForLat = ((10+Random().nextInt(40)) /10000.00).toDouble();
        var randomDeltaForLng = ((10+Random().nextInt(40)) /10000.00).toDouble();

        if (randomOperatorForLat == 1) {
          randomDeltaForLat *= -1;
        }
        if (randomOperatorForLng == 1) {
          randomDeltaForLng *= -1;
        }

        var latFakeNearby =  pickUpLocation.latitude + randomDeltaForLat;
        var lngFakeNearby = pickUpLocation.longitude + randomDeltaForLng;

        var bookedCabCurrentLocation = LatLng(latFakeNearby, lngFakeNearby);

        DirectionsService.init(Constants.kGoogleApiKey);

        final directinosService = DirectionsService();

        final request = DirectionsRequest(
          origin: "${pickUpLocation.latitude} ${pickUpLocation.longitude}",
          //destination: "${dropLocation.latitude} ${dropLocation.longitude}",
          destination: "${bookedCabCurrentLocation.latitude} ${bookedCabCurrentLocation.longitude}",
          travelMode:TravelMode.driving,
        );

        pickUpPath.clear();

        directinosService.route(request,
                (DirectionsResult response, DirectionsStatus status) {
              if (status == DirectionsStatus.ok) {

                if(response.routes.isEmpty){

                  JsonMessage jsonMessage=JsonMessage();
                  jsonMessage.tag=Constants.routesNotAvailable;
                  webSocketListener.onMessage(jsonEncode(jsonMessage));
                }else{

                  var routesList=response.routes.removeLast();

                 // for (DirectionsRoute route in routesList) {
                    OverviewPolyline path = routesList.overviewPolyline;
                    PolyLineLib.PolylinePoints polylinePoints = PolyLineLib.PolylinePoints();
                    List<PolyLineLib.PointLatLng> result = polylinePoints.decodePolyline(path.points);
                    var latlngList=result.map((pointLatLng) => LatLng(pointLatLng.latitude,pointLatLng.longitude));
                    pickUpPath.addAll(latlngList);
                  //}

                  JsonMessage jsonMessage=JsonMessage(Constants.pickUpPath,pickUpPath);

                  webSocketListener.onMessage(jsonEncode(jsonMessage));

                }

              } else {

                JsonMessage jsonMessage=JsonMessage();
                jsonMessage.tag=Constants.errorInRouteFinding;
                webSocketListener.onMessage(jsonEncode(jsonMessage));

              }
            });

    }





}

