import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


typedef AnimationListener = void Function();
typedef UpdatePolyline = void Function();

class AnimatePolyLine {
  List<LatLng> _latLngList;
  Polyline _polyline;
  static const String PolylineID = "12345";
  Set<Polyline> _cabToPickUpLine;
  int _divideInToParts = 10;
  int _repeatCount = 2;
  int _oneAnimDuration = 100;
  AnimationListener _onFinish;
  UpdatePolyline _onUpdate;
  MaterialColor _color = Colors.red;

  AnimatePolyLine(List<LatLng> latLngList, Set<Polyline> cabToPickUpLine,MaterialColor color,
      {AnimationListener onFinish, UpdatePolyline onUpdate}) {
    this._latLngList = latLngList;
    this._cabToPickUpLine = cabToPickUpLine;
    this._color = color;
    this._onUpdate = onUpdate;
    this._onFinish = onFinish;
  }

  animateMe() {
    _polyline = Polyline(
        visible: true,
        polylineId: PolylineId("12345"),
        points: _latLngList,
        color: Colors.black,
        width: 3,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap);

    _animatePolyLine(_polyline, _latLngList);
  }

  _animatePolyLine(Polyline polyline, List<LatLng> latLngList) async {
    _cabToPickUpLine.add(polyline);

    int total = latLngList.length;
    int partition;

    partition = (total / _divideInToParts).ceil();

    for (int i = 0; i <= _repeatCount; i++)
      await Future.delayed(
              Duration(milliseconds: _oneAnimDuration * _divideInToParts))
          .then((_) {
        _animate(latLngList, total, partition, i);
      });
  }

  _animate(List<LatLng> latLngList, int total, int partition, int cycle) async {
    for (int p = partition; p <= total + partition; p = p + partition) {
      await Future.delayed(Duration(milliseconds: _oneAnimDuration)).then((_) {
        List sublist = latLngList.sublist(0, min(p, total));

        _cabToPickUpLine
            .removeWhere((element) => element.polylineId.value != PolylineID);
        _onUpdate();

        Polyline pre = Polyline(
            visible: true,
            polylineId: PolylineId(p.toString()),
            points: sublist,
            color: _color,
            width: 3,
            startCap: Cap.roundCap,
            endCap: Cap.buttCap);

        _cabToPickUpLine.add(pre);
        _onUpdate();
        if (cycle == _repeatCount && p >= total) {
          this._onFinish();
        }
      });
    }

    _cabToPickUpLine
        .removeWhere((element) => element.polylineId.value != PolylineID);
  }
}


