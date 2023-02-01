import 'dart:async';

import 'package:async_api_example/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controllerFirstName = TextEditingController(text: 'Name');

  final _controllerLastName = TextEditingController(text: 'Last Name');

  final _controllerEmail = TextEditingController(text: 'asrock-9@mail.ru');

  final _controllerPhone = TextEditingController(text: '+996555555555');

  final _controllerMessage =
      TextEditingController(text: 'message message message message message ');

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<WeatherProvider>();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Contact',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 32,
              ),
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quam duis vitae curabitur amet, fermentum lorem. ',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            Row(
              children: [
                MyTextInput(
                  controllerFirstName: _controllerFirstName,
                  label: 'First name',
                ),
                MyTextInput(
                  controllerFirstName: _controllerLastName,
                  label: 'Last name',
                ),
              ],
            ),
            MyTextInput(
              controllerFirstName: _controllerEmail,
              label: 'Email',
              error: _errorText,
              onChange: (email) {
                if (vm.isEmailValid(email)) {
                  _errorText = null;
                } else {
                  _errorText = "Enter valid phone or password";
                }
                setState(() {});
              },
            ),
            MyTextInput(
              controllerFirstName: _controllerPhone,
              label: 'Phone',
            ),
            MyTextInput(
              controllerFirstName: _controllerMessage,
              label: 'Message',
            ),
            ElevatedButton(
              onPressed: () {
                if (vm.isEmailValid(_controllerEmail.text)) {
                  vm.sendEmail(
                    context: context,
                    firstName: _controllerFirstName.text,
                    lastName: _controllerLastName.text,
                    email: _controllerEmail.text,
                    phone: _controllerPhone.text,
                    message: _controllerMessage.text,
                  );
                }
              },
              child: const Text('Enter'),
            )
          ],
        ),
      ),
    );
  }
}

class MyTextInput extends StatelessWidget {
  final Function(String text)? onChange;
  final String? error;
  const MyTextInput({
    Key? key,
    required TextEditingController controllerFirstName,
    required this.label,
    this.onChange,
    this.error,
  })  : _controllerFirstName = controllerFirstName,
        super(key: key);

  final TextEditingController _controllerFirstName;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(5),
        child: TextField(
          onChanged: onChange,
          controller: _controllerFirstName,
          decoration: InputDecoration(
            errorText: error,
            label: Text(label),
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
