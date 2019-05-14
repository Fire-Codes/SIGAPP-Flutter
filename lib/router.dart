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
  RouterPage({this.servicio, this.operaciones, this.isAndroid});

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
Future<bool> determinarUsuarioNuevo() async {
  return false;
}

class _RouterPageState extends State<RouterPage> {
  // se inicializa una variable de tipo Authstate a "noIniciado"
  AuthState authState = AuthState.noIniciado;

  // se crea una funcin void para mandar a realizar setState de tipo Iniciado()
  void iniciado() {
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

  Widget _retornarPagina() {
    switch (authState) {
      case AuthState.iniciado:
        // en cao de que no este iniciado entonces manda a la pagina de welcome.dart
        print("desde el router es android?" + this.widget.isAndroid.toString());
        return new WelcomePage(
          servicio: this.widget.servicio,
          onIniciado: this.iniciado,
          isAndroid: this.widget.isAndroid,
        );
        break;
      case AuthState.noIniciado:
        // en caso de que este iniciado entonces manda se raliza un condicional para ver el estado del usuario
        return HomePage(
          isAndroid: this.widget.isAndroid,
          onCerrarSesion: this.noIniciado,
          servicio: this.widget.servicio,
        );
        /*FutureBuilder<bool>(
          future: determinarUsuarioNuevo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.toString() == 'true'
                  ? SignupPage()
                  : HomePage(
                      isAndroid: this.widget.isAndroid,
                      onCerrarSesion: this.noIniciado,
                      servicio: this.widget.servicio,
                    );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // Por Defecto muestra la pagina de iniciando sesion
            return IniciandoSesionPage(
              isAndroid: this.widget.isAndroid,
            );
          },
        );*/
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // se realiza un switch/case para la toma de deciones a ue pagina es que se enviara
    return _retornarPagina();
  }
}
