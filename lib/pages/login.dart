import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sigapp/servicios/servicio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.servicio, this.onIniciado});
  final BaseServicio servicio;

  final VoidCallback onIniciado;

  static String tag = 'login-page';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authh = FirebaseAuth.instance;

  final fs = Firestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void toastError(String error) {
    Fluttertoast.showToast(
        msg: error,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        timeInSecForIos: 5);
  }

  String _nombre;
  String _apellido;
  int _telefono;
  File _profilePicture = null;
  String usuariosRef = "/Vagos/Control/Usuarios/";

  final formKey = new GlobalKey<FormState>();
  final formKeyy = new GlobalKey<FormState>();

  String _email;
  String _password;

  bool validar() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void actualizarDatosUsuarioFirestore(String email, String password,
      int telefono, String displayName, String photoUrl) {
    fs
        .document(usuariosRef + email)
        .updateData({
      'photoProfile': photoUrl,
      'displayName': displayName,
      'Email': email,
      'Contrasena': password,
      'Telefono': telefono
    })
        .then((usuario) => {
    print(
        "Los datos del usuario $email se han actualizado correctamente")
    })
        .catchError((e) => {print(e)});
  }

  /*void iniciarSesion() async {
    if (validar()) {
      try {
        String userEmail = await widget.servicio.iniciarSesion(_email, _password);
        print('Ha Iniciado sesion como: $userEmail');
        Fluttertoast.showToast(
            msg: 'Bienvenido $userEmail',
            backgroundColor: Colors.orange,
            textColor: Colors.white);
        widget.onIniciado();
        Navigator.pop(context);
      } catch (e) {
        bool android = false;
        bool ios = false;
        bool fuchsiaa = false;
        if (Theme.of(context).platform == TargetPlatform.android) {
          android = true;
          ios = false;
          fuchsiaa = false;
          print('Plataforma corriendo en Android');
        } else if (Theme.of(context).platform == TargetPlatform.iOS) {
          ios = true;
          android = false;
          fuchsiaa = false;
          print('Plataforma corriendo en iOS');
        } else if (Theme.of(context).platform == TargetPlatform.fuchsia) {
          fuchsiaa = true;
          android = false;
          ios = false;
          print('Plataforma corriendo en Fuchsia');
        }
        String errorType = '';
        if (android) {
          switch (e.message) {
            case 'There is no user record corresponding to this identifier. The user may have been deleted.':
              errorType = 'Error: El Usuario no Existe!';
              toastError(errorType);
              break;
            case 'The password is invalid or the user does not have a password.':
              errorType = 'Error: La contraseña no es correcta';
              toastError(errorType);
              break;
          /*case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
              errorType =
              'Error: Error de Conexion, por favor verifique su conexión a internet';
              toastError(errorType);
              break;*/
            default:
              toastError(e.toString());
              print('${e.toString()}');
              toastError(e.toString());
          }
        } else if (ios) {
          switch (e.code) {
            case 'Error 17011':
              errorType = 'Error: El Usuario no Existe!';
              toastError(errorType);
              break;
            case 'Error 17009':
              errorType = 'Error: La contraseña no es correcta';
              toastError(errorType);
              break;
          /*case 'Error 17020':
              errorType =
              'Error: Error de Conexion, por favor verifique su conexión a internet';
              toastError(errorType);
              break;*/
            default:
              print('${e.message}');
              toastError(e.message);
          }
        }
        print('El Error Fue $errorType');
      }
    }
  }*/

  /*void iniciarSesionGoogle() async {
    try {
      String userEmail = await widget.auth.iniciarSesionGoogle();
      print('Ha Iniciado Sesión con Google como: ${userEmail}');
      Fluttertoast.showToast(
          msg: 'Bienvenido ${userEmail}',
          backgroundColor: Colors.orange,
          textColor: Colors.white);
      widget.onIniciado();
      Navigator.pop(context);
    } catch (e) {
      bool android = false;
      bool ios = false;
      bool fuchsiaa = false;
      if (Theme.of(context).platform == TargetPlatform.android) {
        android = true;
        ios = false;
        fuchsiaa = false;
        print('Plataforma corriendo en Android');
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        ios = true;
        android = false;
        fuchsiaa = false;
        print('Plataforma corriendo en iOS');
      } else if (Theme.of(context).platform == TargetPlatform.fuchsia) {
        fuchsiaa = true;
        android = false;
        ios = false;
        print('Plataforma corriendo en Fuchsia');
      }
      String errorType = '';
      if (android) {
        switch (e.message) {
          case 'There is no user record corresponding to this identifier. The user may have been deleted.':
            errorType = 'Error: El Usuario no Existe!';
            toastError(errorType);
            break;
          case 'The password is invalid or the user does not have a password.':
            errorType = 'Error: La contraseña no es correcta';
            toastError(errorType);
            break;
          case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
            errorType =
            'Error: Error de Conexion, por favor verifique su conexión a internet';
            toastError(errorType);
            break;
          default:
            toastError(e.toString());
            print('${e.toString()}');
            toastError(e.toString());
        }
      } else if (ios) {
        switch (e.code) {
          case 'Error 17011':
            errorType = 'Error: El Usuario no Existe!';
            toastError(errorType);
            break;
          case 'Error 17009':
            errorType = 'Error: La contraseña no es correcta';
            toastError(errorType);
            break;
          case 'Error 17020':
            errorType =
            'Error: Error de Conexion, por favor verifique su conexión a internet';
            toastError(errorType);
            break;
          default:
            print('${e.message}');
            toastError(e.message);
        }
      }
      print('El Error Fue $errorType');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final loginForm = Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Text(
                  'Inicia sesión para continuar',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15.0,
                      fontFamily: 'SanFrancisco'),
                ),
              ),
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            validator: (value) => value.isEmpty
                                ? 'El email no puede estar en blanco.'
                                : null,
                            onSaved: (value) => _email = value,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                contentPadding:
                                EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0),
                                    ),
                                    borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.grey[200],
                                hasFloatingPlaceholder: true)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autofocus: false,
                          obscureText: true,
                          validator: (value) => value.isEmpty
                              ? 'La contraseña no puede estar en blanco.'
                              : null,
                          onSaved: (value) => _password = value,
                          decoration: InputDecoration(
                              labelText: 'Contraseña',
                              contentPadding:
                              EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      const Radius.circular(30.0)),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: Colors.grey[200]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 48, 0, 16),
                  child: SizedBox(
                    height: 50.0,
                    child: RaisedButton(
                        onPressed: ()=>{},//iniciarSesion,
                        elevation: 6.0,
                        color: Colors.red,
                        child: Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(50.0))),
                  )),
              SizedBox(
                height: 50.0,
                child: RaisedButton(
                    onPressed: () => ()=>{},//iniciarSesionGoogle(),
                    elevation: 7.0,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 15,
                          child: Image.asset('assets/GoogleLogo.jpg'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                          child: Text(
                            '|',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Text('Ingresa con Google',
                              style: TextStyle(
                                  fontFamily: 'SanFrancisco',
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0))),
              ),
              //registrarBtn
            ],
          ),
        ));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme:
        ThemeData(primaryColor: Colors.red, fontFamily: 'SanFrancisco'),
        home: Scaffold(
            backgroundColor: Colors.white,
            body: Builder(
                builder: (context) => Center(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(left: 24.0, right: 24.0),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Center(
                          child: Text(
                            'Te damos la bienvenida a',
                            style: TextStyle(
                                fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                        child: Center(
                          child: Text(
                            'Sigapp',
                            style: TextStyle(
                                color: Colors.red,
                                //color: Colors.black,
                                fontSize: 50.0,
                                fontFamily: 'SanFrancisco'),
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 28.0),
                            loginForm,
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: FlatButton(
                            child: Text('Registrarse',
                                style: TextStyle(
                                    color: Colors.blue[800],
                                    fontSize: 22.0,
                                    fontFamily: 'SanFrancisco',
                                    fontWeight: FontWeight.normal)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignupPage(
                                          /*auth: this.widget.auth,
                                          onIniciado:
                                          this.widget.onIniciado*/)));
                            },
                          ))
                    ],
                  ),
                ))));
  }
}
