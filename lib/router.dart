import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'servicios/servicio.dart';
import 'servicios/operaciones.dart';
import 'pages/login.dart';
import 'pages/signup.dart';
import 'pages/welcome.dart';
import 'pages/home.dart';

class RouterPage extends StatefulWidget {
  // constructor
  RouterPage({this.servicio, this.operaciones});

  // variables inicializadas por parametro de constructor para las funciones del servicio y de las operaciones
  final BaseServicio servicio;
  final BaseOperaciones operaciones;

  @override
  _RouterPageState createState() => _RouterPageState();
}

// variable de tipo enum para los 2 tipos de estado de conexion
enum AuthState { iniciado, noIniciado }

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
  void noIniciado(){
    setState(() {
      authState = AuthState.noIniciado;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
