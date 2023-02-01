import 'package:dio/dio.dart';

void getHttp(String url) async {
  try {
    var response = await Dio().get(url);
    print(response);
  } catch (e) {
    print(e);
  }
}
