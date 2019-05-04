import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'servicios/servicio.dart';
import 'servicios/operaciones.dart';
import 'pages/signup.dart';
import 'pages/welcome.dart';
import 'pages/home.dart';
import 'pages/iniciandoSesion.dart';
import 'dart:io' show Platform;

class RouterPage extends StatefulWidget {
  // constructor
  RouterPage({this.servicio, this.operaciones,this.isAndroid});

  // variables inicializadas por parametro de constructor para las funciones del servicio y de las operaciones
  final BaseServicio servicio;
  final BaseOperaciones operaciones;

  // variable que se pasa por parametro determinando si es dispositivo ios
  final bool isAndroid;

  @override
  _RouterPageState createState() => _RouterPageState();
}

// variable de tipo enum para los 2 tipos de estado de conexion
enum AuthState { iniciado, noIniciado }

// funcion que determinara si es usuario nuevo o no para asi saber a que pagina mandarlo
Future<bool> determinarUsuarioNuevo() async {}

class _RouterPageState extends State<RouterPage> {
  // se inicializa una variable de tipo Authstate a "noIniciado"
  AuthState authState = AuthState.noIniciado;

  // variable que determinara si es ios o android
  bool isAndroid = Platform.isAndroid;

  // se crea una funcin void para mandar a realizar setState de tipo Iniciado()
  void iniciado() {
    print("la plataforma es android: "+this.isAndroid.toString());
    setState(() {
      authState = AuthState.iniciado;
    });
  }

  // se crea una funcion void para mandar a realizar un setState de tipo noIniciado()
  void noIniciado() {
    setState(() {
      authState = AuthState.noIniciado;
    });
  }

  @override
  Widget build(BuildContext context) {
    // se realiza un switch/case para la toma de deciones a ue pagina es que se enviara
    switch (authState) {
      case AuthState.noIniciado:
        // en cao de que no este iniciado entonces manda a la pagina de welcome.dart
        return new WelcomePage(
          servicio: this.widget.servicio,
          onIniciado: this.iniciado,
        );
        break;
      case AuthState.iniciado:
        // en caso de que este iniciado entonces manda se raliza un condicional para ver el estado del usuario
        return FutureBuilder<bool>(
          future: determinarUsuarioNuevo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.toString() == 'true'
                  ? SignupPage()
                  : HomePage();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return IniciandoSesionPage();
          },
        );
        break;
    }
  }
}
