import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_lyft_app/ui/main.dart';

class AnimatePolyLine {
  List<LatLng> _latLngList;
  Polyline _polyline;
  static const String PolylineID="12345";
  MyHomePageState _myHomePageState;
  int _divideInToParts=10;
  int _repeatCount=5;
  int _oneAnimDuration=100;
  AnimationListener _onFinish;

  AnimatePolyLine(List<LatLng> latLngList, Polyline polyline,
      MyHomePageState myHomePageState,{AnimationListener onFinish}) {
    this._latLngList = latLngList;
    this._polyline = polyline;
    this._myHomePageState = myHomePageState;
    this._onFinish=onFinish;
  }

  animateMe() {
    _animatePolyLine(_polyline, _latLngList);
  }

  _animatePolyLine(Polyline polyline, List<LatLng> latLngList) async {
    _myHomePageState.cabToPickUpLine.add(polyline);

    int total = latLngList.length;
    int partition;

    partition = (total / _divideInToParts).ceil();

    for (int i = 0; i <= _repeatCount; i++)
      await Future.delayed(Duration(milliseconds: _oneAnimDuration * _divideInToParts)).then((_) {
        _myHomePageState.setState(() {
          _animate(latLngList, total, partition,i);
        });
      });
  }

  _animate(List<LatLng> latLngList, int total, int partition,int cycle) async {
    for (int p = partition; p <= total + partition; p = p + partition) {
      await Future.delayed(Duration(milliseconds: _oneAnimDuration)).then((_) {
        _myHomePageState.setState(() {
          List sublist = latLngList.sublist(0, min(p, total));
          _myHomePageState.cabToPickUpLine
              .removeWhere((element) => element.polylineId.value != PolylineID);
          Polyline pre = Polyline(
              visible: true,
              polylineId: PolylineId(p.toString()),
              points: sublist,
              color: Colors.blue,
              width: 3,
              startCap: Cap.roundCap,
              endCap: Cap.buttCap);

          _myHomePageState.cabToPickUpLine.add(pre);
          if(cycle==_repeatCount && p>total){
            this._onFinish();
          }
        });
      });
    }

    _myHomePageState.cabToPickUpLine
        .removeWhere((element) => element.polylineId.value != PolylineID);
  }
}

typedef AnimationListener = void Function();


