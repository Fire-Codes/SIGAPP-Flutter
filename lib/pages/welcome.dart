import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sigapp/servicios/servicio.dart';

class WelcomePage extends StatefulWidget {
  // constructor
  WelcomePage({this.servicio, this.onIniciado});

  // se inicializan las variables que se pasan por parametro desde el constructor para el servicio
  final BaseServicio servicio;
  final VoidCallback onIniciado;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WelcomePage',
        ),
      ),
    );
  }
}
