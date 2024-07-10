import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mc/pages/weather/weather_model.dart';

class WeatherServices {
  fetchWeather() async {
    final response = await http.get(
      Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?lat=6.8195&lon=79.8801&appid=0bd091e26f1685548618bcb75bbfa27c"),
    );

    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load Weather data');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
