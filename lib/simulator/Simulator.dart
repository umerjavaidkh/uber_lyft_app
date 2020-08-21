
import 'dart:convert';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_lyft_app/utils/Constants.dart';

import 'WebSocketListener.dart';

class Simulator{




    static getFakeNearByCabs(LatLng userLoc,WebSocketListener webSocketListener){

    var size = Random().nextInt(6);

    List nearByCabs= List<LatLng>();

    JsonMessage jsonMessage=JsonMessage();
    jsonMessage.tag=Constants.requestForCabs;

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


}

class JsonMessage{

  String tag;
  List<LatLng>   data;

  JsonMessage({this.tag, this.data}){
    this.tag;
    this.data;
  }

  JsonMessage.fromJson(Map<String, dynamic> json){
    tag = json['tag'];
    //data = List.castFrom<dynamic, LatLng>(json['data']); //json['data'].cast<List<LatLng>>();
    data=List<LatLng>();
    for (var item in json['data']) {
      data.add(LatLng.fromJson(item));
    }

  }


  Map<String, dynamic> toJson() => {
    'tag':tag,
    'data': data,
  };



}