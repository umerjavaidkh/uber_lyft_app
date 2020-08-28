import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;
import 'package:uber_lyft_app/utils/MapUtils.dart';


typedef  MarkerUpdateListener=Function(Marker currentMarker);


class AnimateMarker{

  int _divideInToParts=10;
  int _oneAnimDuration=90;

  MarkerUpdateListener _onMarkerPosUpdate;

  AnimateMarker({MarkerUpdateListener onMarkerPosUpdate}){
    _onMarkerPosUpdate=onMarkerPosUpdate;
  }

  animaterMarker(LatLng from, LatLng to,Marker marker) async{

    List<maps_toolkit.LatLng> list=List();
    List<double> angleList=List();

    maps_toolkit.LatLng tempPre=maps_toolkit.LatLng(from.latitude,from.longitude);
    for(int start=1; start<=_divideInToParts;start++ ) {
      maps_toolkit.LatLng tempLatlng = maps_toolkit.SphericalUtil.interpolate(
          maps_toolkit.LatLng(from.latitude, from.longitude),
          maps_toolkit.LatLng(to.latitude, to.longitude), start/_divideInToParts);
      list.add(tempLatlng);
      double angle=MapUtils.getRotation(LatLng(tempPre.latitude,tempPre.longitude),LatLng(tempLatlng.latitude,tempLatlng.longitude));
      tempPre=tempLatlng;
      angleList.add(angle);
    }

    for (int index=0; index<list.length; index++){
      maps_toolkit.LatLng item = list[index];
      await Future.delayed(Duration(milliseconds: _oneAnimDuration)).then((_) {

        Marker tempM = Marker(
          markerId: marker.markerId,
          position: LatLng(item.latitude, item.longitude),
          anchor: marker.anchor,
          rotation: angleList[index],
          icon: marker.icon,
        );

        _onMarkerPosUpdate(tempM);

          if(index==list.length-1){
          list.clear();
          angleList.clear();
          }

      });
    }
  }

}