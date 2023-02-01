import 'dart:async';

import 'package:async_api_example/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'weather_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => WeatherProvider()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  Timer? timer;
  String currentCity = 'Бишкек';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherProvider>();
    if (vm.model == null) vm.getWeather();

    print('Build');
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff08244F),
              Color(0xff134CB5),
              Color(0xff0B42AB),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: TextEditingController(text: currentCity),
                decoration: InputDecoration(),
                style: TextStyle(color: Colors.white),
                onChanged: (val) {
                  // print(val);
                  timer?.cancel();
                  timer = Timer(
                    const Duration(seconds: 1),
                    () {
                      if (val.length >= 2 && currentCity != val)
                        vm.getWeather(city: val);
                      currentCity = val;
                    },
                  );

//                 timer = Timer(
//                     const Duration(seconds: 5), () => print('Timer finished'));
// // Cancel timer, callback never called.
//                 timer.cancel();
                },
              ),
            ),
            Text(
              '${vm.model?.name ?? 'Loading'}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 200,
              child: Image.asset(vm.image),
            ),

            // Image.network(
            //     'http://openweathermap.org/img/wn/${vm.model?.weather?[0].icon ?? '01n'}.png')
            Text(
              "${vm.model?.main?.temp ?? 'Loading'}\u00b0",
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const Text(
              "Precipitations",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            Text(
              "Max.: ${vm.model?.main?.tempMax}º   Min.: ${vm.model?.main?.tempMin}º",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            Container(
              height: 47,
              margin: const EdgeInsets.only(left: 40, right: 40),
              decoration: BoxDecoration(
                color: const Color(0xff001026),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 30),
                  ChipWidget(
                    image: 'assets/vlaj.png',
                    str: '${vm.model?.main?.humidity}%',
                  ),
                  Spacer(),
                  ChipWidget(
                    image: 'assets/humudity.png',
                    str: '${vm.model?.main?.humidity}%',
                  ),
                  Spacer(),
                  ChipWidget(
                    image: 'assets/wind.png',
                    str: '${vm.model?.wind?.speed}km/h',
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40, top: 20),
              decoration: BoxDecoration(
                color: const Color(0xff001026),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Text(
                          DateFormat.MMMd().format(DateTime.now()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Text(
                      "${vm.model?.main?.temp ?? 'Loading'}\u00b0C",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    Image.network(
                        'http://openweathermap.org/img/wn/${vm.model?.weather?[0].icon ?? '01n'}.png'),
                    Text(
                      DateFormat.Hm().format(DateTime.now()),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     print('BuildButton');
      //     vm.getWeather();
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}

class ChipWidget extends StatelessWidget {
  final String image, str;
  const ChipWidget({
    Key? key,
    required this.image,
    required this.str,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(image),
        const SizedBox(width: 5),
        Text(
          str,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
