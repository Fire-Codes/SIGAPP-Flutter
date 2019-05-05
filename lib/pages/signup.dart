import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignupPage extends StatefulWidget {
  // constructor
  SignupPage({this.isAndroid});
  // se crea una variable que se inicializa mediante paso por valor para detectar la plataforma en la que esta corriendo la aplicacion
  bool isAndroid;
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.red,
          platform: this.widget.isAndroid
              ? TargetPlatform.android
              : TargetPlatform.iOS),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'SignupPage',
          ),
        ),
      ),
    );
  }
}
