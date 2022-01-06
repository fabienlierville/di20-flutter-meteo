import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiGeocoder{
  String baseUrlAdress = "http://api.openweathermap.org/geo/1.0/direct?";
  String baseUrlReverse = "http://api.openweathermap.org/geo/1.0/reverse?";
  String apiKey;

  ApiGeocoder({required this.apiKey});

  ///
  /// Donne la ville selon les coordonnéees GPS
  ///
  Future<String?> getAdressFromCoordinates({required double latitude, required double longitude}) async{
    String completeUrl = "${baseUrlReverse}lat=${latitude}&lon=${longitude}&appid=${apiKey}";
    print(completeUrl);
    http.Request request = http.Request('GET', Uri.parse(completeUrl));

    http.StreamedResponse response = await request.send();

    if(response.statusCode == 200){
      String body = await response.stream.bytesToString();
      List<dynamic> result = jsonDecode(body);
      return result.first["name"];
    }

    return null;
  }

  ///
  /// Donne les coordonnées GPS selon la ville
  /// {lat:4343243,lon:4453435433}
  Future<Map<String,dynamic>?> getCoordinatesFromAddress({required String ville}) async{
    String completeUrl = "${baseUrlAdress}q=${ville}&appid=${apiKey}";
    print(completeUrl);
    http.Request request = http.Request('GET', Uri.parse(completeUrl));

    http.StreamedResponse response = await request.send();

    if(response.statusCode == 200){
      String body = await response.stream.bytesToString();
      List<dynamic> result = jsonDecode(body);
      return {
        "latitude" : result.first["lat"],
        "longitude" : result.first["lon"]
      };
    }

    return null;

  }

}