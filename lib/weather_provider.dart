import 'package:async_api_example/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherModel? model;
  String image = 'assets/other.png';
  String smallIcon = '';
  String url =
      'https://api.openweathermap.org/data/2.5/weather?lat=42.8746&lon=74.5698&appid=6524354205ea10f1b2a9a460b17d52b1&units=metric&lang=ru';
  Future<void> getWeather({String city = 'Bishkek'}) async {
    url =
        'https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=6524354205ea10f1b2a9a460b17d52b1&units=metric&lang=ru';
    Dio dio = Dio();
    final response = await dio.get(url);
    model = WeatherModel.fromJson(response.data);
    if (model?.weather?[0].main == 'rain') {
      image = 'assets/rain.png';
    }

    notifyListeners();
  }

  // Future<void> getSmallIcon(String icon) async {
  //   Dio dio = Dio();
  //   final response =
  //       await dio.get('http://openweathermap.org/img/wn/${icon}@2x.png');
  //   model = WeatherModel.fromJson(response.data);
  //   if (model?.weather?[0].main == 'rain') {
  //     image = 'assets/rain.png';
  //   }
  // }
}
