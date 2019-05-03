import 'package:flutter/material.dart';
import 'servicios/servicio.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

Future<dynamic> extraerNotas() async {
  final response = await http.post(
      'https://portalestudiantes.unanleon.edu.ni/consulta_estudiantes.php',
      body: {
        'carnet': '16-02095-0',
        'pin': 'RWLKCY',
        'anyo_lec': '2016',
        'tipo': '',
        'mandar': 'Visualizar',
        'npag': '2',
      });
  /*final response =
  await http.get('https://www.google.com');*/

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    if (response.body.toString().contains("alert('PIN no válido');")) {
      print('Pin no valido');
      return "Pin no válido";
    } else {
      var tabla = await Servicio()
          .retornarTabla(response.body.toString())
          .then((String tabla) {
        return tabla;
      }).catchError((e) {
        print(e.toString());
      });
      return await tabla.toString();
    }
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class MyApp extends StatefulWidget {
  final Future<dynamic> post;
  MyApp({Key key, this.post}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<dynamic> post;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIGAPP',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('SIGAPP Test'),
        ),
        body: FutureBuilder<dynamic>(
          future: extraerNotas(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[Text(snapshot.data.toString())],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
