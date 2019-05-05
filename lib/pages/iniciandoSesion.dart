import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IniciandoSesionPage extends StatefulWidget {
  // constructor
  IniciandoSesionPage({this.isAndroid});

  // se declara una variable inicializada mediante paso por valor desde el constructor con el tipo de platafoma en la cual esta corriendo la aplicacion
  final bool isAndroid;

  @override
  _IniciandoSesionPageState createState() => _IniciandoSesionPageState();
}

Future<void> _mostrarDialog(BuildContext context, bool isAndroid) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return isAndroid
          ? AlertDialog(
              title: Text(
                'Iniciando Sesion',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ))
                  ],
                ),
              ),
            )
          : CupertinoAlertDialog(
              title: Text(
                'Iniciando Sesion',
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoActivityIndicator(
                        animating: true,
                        radius: 15.0,
                      ),
                    ))
                  ],
                ),
              ),
            );
    },
  );
}

class _IniciandoSesionPageState extends State<IniciandoSesionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => _mostrarDialog(context, this.widget.isAndroid));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
        platform:
            this.widget.isAndroid ? TargetPlatform.android : TargetPlatform.iOS,
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/backgroundImages/iniciandoSesion.jpg"),
          )),
        ),
      ),
    );
  }
}
