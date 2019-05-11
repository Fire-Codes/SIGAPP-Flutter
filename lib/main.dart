import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'servicios/operaciones.dart';
import 'servicios/servicio.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'router.dart';

void main() {
  runApp(MyApp());
}

// funcion que ejecuta la peticion http a los servidores de la unan leon
Future<List> extraerNotas() async {
  int vueltas = 0;
  int anoLectivo = 2016;
  List<String> responses = new List<String>();
  bool continuar = true;
  do {
    final response = await http.post(
        'https://portalestudiantes.unanleon.edu.ni/consulta_estudiantes.php',
        body: {
          'carnet': '16-02095-0',
          'pin': 'RWLKCY',
          'anyo_lec': '$anoLectivo',
          'tipo': '',
          'mandar': 'Visualizar',
          'npag': '2',
        });
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      if (response.body.toString().contains("alert('PIN no válido');")) {
        print('Pin no valido');
        continuar = false;
        //return "Pin no válido";
      } else if (response.body
          .toString()
          .contains("window.alert('No han registrado las notas');")) {
        print('Aun no se han registrado las notas para este año');
        continuar = false;
        //return "Aun no se han registrado las notas para este año";
      } else {
        var tabla = await Operaciones()
            .retornarTabla(response.body.toString())
            .then((String tabla) {
          return tabla;
        }).catchError((e) {
          print(e.toString());
        });
        responses.add(await tabla.toString());
        vueltas++;
        anoLectivo++;
      }
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  } while (continuar);
  return await responses;
  /*final response =
  await http.get('https://www.google.com');*/
}

Future<String> extraerPentsum() async {
  final response = await http
      .get('https://portalestudiantes.unanleon.edu.ni/pensum_academico.php');

  if (response.statusCode == 200) {
    var tabla = await Operaciones()
        .extraerCodigosFacultad(response.body.toString())
        .then((String tabla) {
      return tabla;
    }).catchError((e) {
      print(e.toString());
    });
    return await tabla.toString();
  }
}

class MyApp extends StatefulWidget {
  final Future<dynamic> post;
  // variable que determinara el sistema operativo en el que se esta corriendo
  final bool isAndroid = Platform.isAndroid;
  MyApp({Key key, this.post}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  // instancia de el fcm de firebase
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // lista de los tabs que se mostraran en la parte principal
  final List<Tab> tabs = <Tab>[
    Tab(
      text: '2016',
    ),
    Tab(
      text: '2017',
    ),
    Tab(
      text: '2018',
    ),
  ];

  // instancia del controlador de los tabs
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseCloudMessaging_Listeners();
    _tabController = TabController(vsync: this, length: tabs.length);
    print("es android: " + this.widget.isAndroid.toString());
  }

  // funcion para habilitar a la escucha las funciones de fcm
  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    _firebaseMessaging.getToken().then((token) async {
      await Servicio().subirFCMToken(token).then((onvalue) {}).catchError((e) {
        print(e.toString());
      });
      print("Tu fcm toke es:" + token);
    });
  }

  // funcion para habilitar los permisos de ios
  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SIGAPP',
        theme: ThemeData(
          primarySwatch: Colors.red,
          platform: this.widget.isAndroid
              ? TargetPlatform.android
              : TargetPlatform.iOS,
        ),
        home: Scaffold(
            body: FutureBuilder<dynamic>(
          future: extraerPentsum(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[Text(snapshot.data.toString())],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        )
            /*FutureBuilder<List<dynamic>>(
            future: extraerNotas(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctx, int index){
                    return Text(snapshot.data[index].toString());
                  },
                );
                /*TabBarView(
                  controller: _tabController,
                  children: tabs.map((Tab tab) {
                    return Center(child: Text(tab.text));
                  }).toList(),
                );*/
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner
              return Center(child: CircularProgressIndicator());
            },
          ),*/
            )
        /*new RouterPage(
          servicio: new Servicio(
            isAndroid: this.widget.isAndroid,
          ),
          isAndroid: this.widget.isAndroid,
        )*/ /*Scaffold(
        appBar: AppBar(
          title: Text('SIGAPP Test'),
          bottom: TabBar(
            controller: _tabController,
            tabs: tabs,
            isScrollable: true,
          ),
        ),
        body: FutureBuilder<dynamic>(
          future: extraerNotas(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return TabBarView(
                controller: _tabController,
                children: tabs.map((Tab tab) {
                  return Center(child: Text(tab.text));
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),*/
        );
  }
}
