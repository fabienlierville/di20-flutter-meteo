import 'package:flutter/material.dart';
import 'package:meteo/api/api_geocoder.dart';
import 'package:meteo/api/api_weather.dart';
import 'package:meteo/models/device_info.dart';
import 'package:meteo/models/meteo.dart';
import 'package:meteo/my_flutter_app_icons.dart';
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
  Meteo? meteo;


  @override
  void initState() {
    obtenir();
    getMeteo(DeviceInfo.ville!);
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
      body: (meteo == null)
      ? Center(child: CustomText("Pas de méteo disponible"),)
      : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(meteo!.getMainWeatherImage()),
                fit: BoxFit.cover)),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(villeChoisie ?? "", style: TextStyle(fontSize: 30, color: Colors.white),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${meteo!.temperature.toStringAsFixed(1)} °C",style: TextStyle(fontSize: 60, color: Colors.white),),
                Image.asset(meteo!.getIconeImage())
              ],
            ),
            Text(meteo!.weatherMain, style: TextStyle(fontSize: 30, color: Colors.white),),
            Text(meteo!.weatherDescription, style: TextStyle(fontSize: 25, color: Colors.white),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(MyFlutterApp.temperatire, color: Colors.white,),
                    Text(meteo!.pressure.toInt().toString(), style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
                Column(
                  children: [
                    Icon(MyFlutterApp.droplet, color: Colors.white),
                    Text(meteo!.humidity.toInt().toString(), style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
                Column(
                  children: [
                    Icon(MyFlutterApp.arrow_upward, color: Colors.white),
                    Text(meteo!.temperatureMax.toStringAsFixed(1), style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
                Column(
                  children: [
                    Icon(MyFlutterApp.arrow_downward, color: Colors.white),
                    Text(meteo!.temperatureMin.toStringAsFixed(1), style: TextStyle(fontSize: 20, color: Colors.white),),
                  ],
                ),
              ],
            )
          ],
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
    ApiGeocoder geocoder = ApiGeocoder(apiKey: "959d1296a89c3365a20b001a440c4eb3");
    Map<String,dynamic>? coordinates = await geocoder.getCoordinatesFromAddress(ville: ville);
    print(coordinates);

    if(coordinates != null){
      //2. Interroger l'api meteo
      ApiWeather weather = ApiWeather(apiKey: "959d1296a89c3365a20b001a440c4eb3");
      Meteo? meteoApi = await weather.getCurrentWeather(latitude: coordinates["latitude"], longitude: coordinates["longitude"]);
      if(meteoApi != null){
        setState(() {
          meteo = meteoApi;
          villeChoisie = ville;
        });
      }
    }


  }

}
