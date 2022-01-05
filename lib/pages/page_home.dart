import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Météo"),
      ),
      body: Center(),
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

}
