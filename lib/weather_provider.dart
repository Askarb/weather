import 'dart:convert';
import 'dart:io';

import 'package:async_api_example/weather_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class WeatherProvider extends ChangeNotifier {
  bool onProcess = false;
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

  Future<void> sendEmail({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String message,
  }) async {
    if (onProcess) return;
    onProcess = true;

    String htmlTemplate = '''
<body>
<h2>${firstName} ${lastName}  Ваша заявка принята</h2>
<h3>Phone: <b>${phone}</b></h3>
<h3>Message: <b>${message}</b></h3>
''';

    Dio dio = Dio();
    try {
      Response response = await dio.post(
        'https://api.mailazy.com/v1/mail/send',
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            'X-Api-Key': 'c96n7a1opc08t8plo1h0GcCYRpAbKP',
            'X-Api-Secret':
                'mjXoErfTGDWMsmtzgjWTqMHnNMQ.XToPbTibcMiUGodrmUjxTB',
          },
        ),
        data: jsonEncode(
          {
            "to": [email],
            "from": "Sender <info@richmate.ru>",
            "reply_to": "Flutter Test <info@richmate.ru>",
            "subject": 'Обратная связь',
            "content": [
              {"type": "text/html", "value": htmlTemplate}
            ]
          },
        ),
      );
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Email sent"),
          content: Text("Email успешно отправлен"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Ok"),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Email sent error"),
          content: Text("Email НЕ отправлен"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Ok"),
            ),
          ],
        ),
      );
    }
    onProcess = false;
  }

  bool isEmailValid(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
}
