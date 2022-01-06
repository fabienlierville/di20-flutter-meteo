import 'package:flutter/material.dart';
import 'package:meteo/models/device_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  List<String> villes = [];
  String? villeChoisie;

  @override
  void initState() {
    obtenir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Météo"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Ajouter Ville"),
          onPressed: (){
            print(villes);
            ajouter("Rouen");
            print(villes);
            print(DeviceInfo.locationData.toString());
            print(DeviceInfo.ville);
          },
        ),
      ),
    );
  }

  Future<void> obtenir() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? liste = prefs.getStringList("villes");
    if(liste != null){
      setState(() {
        villes = liste;
      });
    }
  }

  Future<void> ajouter(String value) async{
    if(villes.contains(value)){
      return; //Anti doublon
    }
    villes.add(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("villes", villes);
    obtenir();
  }

  Future<void> supprimer(String value) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    villes.remove(value);
    await prefs.setStringList("villes", villes);
    obtenir();
  }

}
