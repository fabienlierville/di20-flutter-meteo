
class Meteo{
  final String weatherMain;
  final String weatherDescription;
  final String weatherIcon;
  final double temperature;
  final double temperatureMin;
  final double temperatureMax;
  final double pressure;
  final double humidity;

  Meteo({
    required this.weatherMain,
    required this.weatherDescription,
    required this.weatherIcon,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.pressure,
    required this.humidity
  });

  static Meteo FromJson(Map<String,dynamic> json){
    return Meteo(
      weatherMain: json["weather"][0]["main"],
      weatherDescription: json["weather"][0]["description"],
      weatherIcon: json["weather"][0]["icon"],
      temperature: double.tryParse(json["main"]["temp"].toString()) ?? 0,
      temperatureMin: double.tryParse(json["main"]["temp_min"].toString()) ?? 0,
      temperatureMax: double.tryParse(json["main"]["temp_max"].toString()) ?? 0,
      pressure: double.tryParse(json["main"]["pressure"].toString()) ?? 0,
      humidity: double.tryParse(json["main"]["humidity"].toString()) ?? 0,
    );
  }

  String getMainWeatherImage(){
    if(weatherIcon.contains("n")){
      return "assets/img/n.jpg";
    }else{
      if(weatherIcon.contains("01") || weatherIcon.contains("02") || weatherIcon.contains("03")){
        return "assets/img/d1.jpg";
      }else{
        return "assets/img/d2.jpg";
      }
    }
  }

  String getIconeImage(){
    String logo = weatherIcon.replaceAll("d", "").replaceAll("n", "");
    return "assets/img/$logo.png";
  }


}