import 'package:flutter/material.dart';
import 'package:meteo/api/api_geocoder.dart';
import 'package:meteo/models/device_info.dart';
import 'package:meteo/widgets/custom_text.dart';
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
      drawer: Drawer(
        child: Container(
          color: Colors.blue,
          child: Column(
            children: [
              // Header
              DrawerHeader(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomText("Villes", fontSize: 30.0, color: Colors.white,),
                      ElevatedButton(
                          onPressed: ajoutVille,
                          child: CustomText("Ajouter une ville", color: Colors.blue,),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                      )
                    ],
                  )
              ),
              // Ville du Device
              ListTile(
                onTap: (){
                  getMeteo(DeviceInfo.ville!);
                },
                title: CustomText(DeviceInfo.ville!, color: Colors.white,textAlign: TextAlign.center,),
              ),
              // Listes des villes SharedPreferences
              Expanded(
                  child: ListView.builder(
                    itemCount: villes.length,
                      itemBuilder: (context, index){
                        String ville = villes[index];
                        return ListTile(
                          onTap: (){
                            getMeteo(ville);
                          },
                          title: CustomText(ville, color: Colors.white,textAlign: TextAlign.center,),
                          trailing: IconButton(
                            onPressed: (){
                              supprimer(ville);
                            },
                            icon: Icon(Icons.delete, color: Colors.white,),
                          ),
                        );
                      }
                  )
              )
            ],
          ),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Ajouter Ville"),
          onPressed: () async{
            print(villes);
            ajouter("Rouen");
            print(villes);
            print(DeviceInfo.locationData.toString());
            print(DeviceInfo.ville);

            ApiGeocoder geocoder = ApiGeocoder(apiKey: "959d1296a89c3365a20b001a440c4eb3");
            Map<String,dynamic>? coordinates = await geocoder.getCoordinatesFromAddress(ville: "Bangok");
            print(coordinates);
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

  Future<void> ajoutVille(){
    String? villeSaisie;
    return showDialog(
        context: context,
        builder: (contextDialog){
          return SimpleDialog(
            contentPadding: EdgeInsets.all(20),
            title: CustomText("Ajoutez une ville", color: Colors.blue,),
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText:  "ville",
                  hintText: "saisir ville"
                ),
                onChanged: (String value){
                  villeSaisie = value;
                },
              ),
              ElevatedButton(
                  onPressed: (){
                    if(villeSaisie != null){
                      ajouter(villeSaisie!);
                      Navigator.pop(contextDialog);
                    }
                  },
                  child: CustomText("Valier")
              ),
            ],
          );
        }
    );
  }

  Future<void> getMeteo(String ville) async{
    //1. conversion de la ville en lat/long

    //2. Interroger l'api meteo


  }

}
