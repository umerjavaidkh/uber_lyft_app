import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import '../main.dart';

Future<Prediction> getPaceOverlay (BuildContext context) async{

   return await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.overlay, // Mode.fullscreen
        language: "en",
        components: [new Component(Component.country, "ae")]);

  }