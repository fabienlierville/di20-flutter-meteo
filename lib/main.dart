import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:meteo/api/api_geocoder.dart';
import 'package:meteo/models/device_info.dart';
import 'package:meteo/pages/page_home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Location location = Location();

  bool _serviceEnabled = await location.serviceEnabled();
  if(!_serviceEnabled){
    _serviceEnabled = await location.requestService();
    if(!_serviceEnabled){
      return;
    }
  }

  PermissionStatus _persmissionGranted = await location.hasPermission();
  if(_persmissionGranted == PermissionStatus.denied){
    _persmissionGranted = await location.requestPermission();
    if(_persmissionGranted != PermissionStatus.granted){
      return;
    }
  }

  LocationData _locationData =  await location.getLocation();
  print("Location = ${_locationData.latitude},${_locationData.longitude}");
  DeviceInfo.locationData = _locationData;

  if(_locationData != null){
    ApiGeocoder geocoder = ApiGeocoder(apiKey: "959d1296a89c3365a20b001a440c4eb3");
    String? ville = await geocoder.getAdressFromCoordinates(latitude: _locationData.latitude!, longitude: _locationData.longitude!);
    DeviceInfo.ville = ville;

    runApp(const MyApp());
  }



}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PageHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
