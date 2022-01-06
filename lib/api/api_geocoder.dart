import 'package:http/http.dart' as http;

class ApiGeocoder{
  String baseUrlAdress = "http://api.openweathermap.org/geo/1.0/direct?";
  String baseUrlReverse = "http://api.openweathermap.org/geo/1.0/reverse?";
  String apiKey;

  ApiGeocoder({required this.apiKey});

  Future<String> getAdressFromCoordinates({required double latitude, required double longitude}){
    http.Request request = http.Request('GET', Uri.parse("${baseUrlReverse}lat=${latitude}&lon=${longitude}&appid=${apiKey}"));



  }

}