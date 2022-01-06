
import 'dart:convert';

import 'package:meteo/models/meteo.dart';
import 'package:http/http.dart' as http;

class ApiWeather{
  String baseUrl = "https://api.openweathermap.org/data/2.5/";
  String apiKey;

  ApiWeather({required this.apiKey});

  ///
  /// Donne un objet Meteo selon les coordonnéees GPS
  ///
  Future<Meteo?> getCurrentWeather({required double latitude, required double longitude}) async{
    String completeUrl = "${baseUrl}/weather?lat=${latitude}&lon=${longitude}&appid=${apiKey}&lang=fr&units=metric";
    print(completeUrl);
    http.Request request = http.Request('GET', Uri.parse(completeUrl));

    http.StreamedResponse response = await request.send();

    if(response.statusCode == 200){
      String body = await response.stream.bytesToString();
      return Meteo.FromJson(jsonDecode(body));
    }

    return null;
  }

}