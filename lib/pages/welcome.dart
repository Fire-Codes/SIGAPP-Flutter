import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sigapp/servicios/servicio.dart';
import 'package:sigapp/pages/login.dart';

class WelcomePage extends StatefulWidget {
  // constructor
  WelcomePage({this.servicio, this.onIniciado, this.isAndroid});

  // se crean las variables que se inicializan mediante paso de valor por parametro del constructor
  final BaseServicio servicio;
  final VoidCallback onIniciado;

  // se crea una variable para determinar la plataforma en la que la aplicacion esta corriendo para la toma de decisiones en el diseño de la aplicacion
  final bool isAndroid;
  static String tag = 'welcome-page';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

Widget _retorno(BuildContext context, VoidCallback onIniciado,
    BaseServicio servicio, bool isAndroid) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
              child: CircleAvatar(
                child: Image.asset('assets/SIGAPPLogo.png'),
                radius: 40.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'SIGAPP',
                style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'SanFrancisco'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 30, 5, 20),
              child: Text(
                'Administra todas tus transacciones universitarias desde un solo lugar con \"SIGAPP\".',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                    fontFamily: 'SanFrancisco'),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: isAndroid
                  ? RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(
                                  servicio: servicio,
                                  onIniciado: onIniciado,
                                  isAndroid: isAndroid,
                                ),
                          ),
                        );
                      },
                      elevation: 8.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: Text(
                          'EMPEZAR',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SanFrancisco'),
                        ),
                      ),
                      // color: Colors.blue[900],
                      color: Colors.red,
                    )
                  : CupertinoButton(
                      color: Colors.red,
                      child: Text(
                        'EMPEZAR',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SanFrancisco'),
                      ),
                      onPressed: () {
                        isAndroid
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(
                                        servicio: servicio,
                                        onIniciado: onIniciado,
                                        isAndroid: isAndroid,
                                      ),
                                ),
                              )
                            : Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => LoginPage(
                                        servicio: servicio,
                                        onIniciado: onIniciado,
                                        isAndroid: isAndroid,
                                      ),
                                ),
                              );
                      },
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Powered by FireLabs',
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.0,
                      fontFamily: 'SanFrancisco'),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, bottom: 20.0),
                  child: Text(
                    'Edycar Reyes',
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14.0,
                        fontFamily: 'SanFrancisco',
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return this.widget.isAndroid
        ? MaterialApp(
            theme: ThemeData(
              primaryColor: Colors.red,
              platform: this.widget.isAndroid
                  ? TargetPlatform.android
                  : TargetPlatform.iOS,
            ),
            home: _retorno(
              context,
              this.widget.onIniciado,
              this.widget.servicio,
              this.widget.isAndroid,
            ),
          )
        : CupertinoApp(
            theme: CupertinoThemeData(primaryColor: Colors.red),
            home: _retorno(
              context,
              this.widget.onIniciado,
              this.widget.servicio,
              this.widget.isAndroid,
            ),
          );
  }
}
