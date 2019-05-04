import 'package:flutter/material.dart';
import 'servicios/servicio.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

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
    } else if (response.body
        .toString()
        .contains("window.alert('No han registrado las notas');")) {
      print('Aun no se han registrado las notas para este año');
      return "Aun no se han registrado las notas para este año";
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

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  Future<dynamic> post;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
    Tab(
      text: '2019',
    ),
  ];

  bool extraido = false;

  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseCloudMessaging_Listeners();
    _tabController = TabController(vsync: this, length: tabs.length);
  }

  void firebaseCloudMessaging_Listeners() {
    // if (Platform.isIOS) iOS_Permission();

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
      ),
      home: Scaffold(
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
      ),
    );
  }
}
