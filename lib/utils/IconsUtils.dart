
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IconUtils{


  static Future <BitmapDescriptor> createMarkerImageFromAsset() async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapImage = await BitmapDescriptor.fromAssetImage(
        configuration,"assets/images/ic_car.png");
    return bitmapImage;
  }

}