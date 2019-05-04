import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IniciandoSesionPage extends StatefulWidget {
  @override
  _IniciandoSesionPageState createState() => _IniciandoSesionPageState();
}

Future<void> _mostrarDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
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
      );
    },
  );
}

class _IniciandoSesionPageState extends State<IniciandoSesionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _mostrarDialog(context));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue
      ),
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/backgroundImages/iniciandoSesion2.jpg"),
          )),
        ),
      ),
    );
  }
}
