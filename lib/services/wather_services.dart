import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_api/models/weather_api.dart';

class WeatherService {
  Future<Weather> getWeaterData() async {
    String url =
        'http://api.weatherapi.com/v1/forecast.json?key=f9a49cf11da749fc8c6181227221612&q=$city&days=1&aqi=no&alerts=no';
    final uri = Uri.parse(url);
    final responce = await http.get(uri);
    if(responce.statusCode == 200){
      return Weather.fromJson(jsonDecode(responce.body)); 
    }else{
      throw Exception('Failed');
    }
  }
}

String city='malappuram';
