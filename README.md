# uber_lyft_app

A new Flutter application.

# To Run

Go to ios/runner then AppDelegate.swift 
replace GMSServices.provideAPIKey("your_key_here") with your key.

Go to android/app/src/main then AndroidManifest.xml
replace android:value="your_key_here"  with your key.

Go to lib/utils Constants.dart 
replace const kGoogleApiKey = "your_key_here" with your key.

Go to bib/utils/RequestPlace.dart
line 14:  components: [new Component(Component.country, "ae")]); 
change "ae" to your respective country.

You also have to enable Google Places Api for flutter_google_places: ^0.2.6 to work.


<p align="center">
    <img src="https://miro.medium.com/max/2000/1*WRp686xdFbGW3nGfu4am0A.jpeg">
</p>
<br>





## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
