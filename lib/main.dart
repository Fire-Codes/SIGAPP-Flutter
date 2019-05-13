import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'servicios/operaciones.dart';
import 'servicios/servicio.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:sigapp/clases/pensums/carrera.dart';

void main() {
  runApp(MyApp());
}

List<Carrera> peticionesParaPlanes = new List<Carrera>();
Carrera carrera = new Carrera();
int contador = 0;

Future<void> recorrerLista() async {
  peticionesParaPlanes.forEach((Carrera carrera) async {
    var responseFormateado = carrera.getResponse();
    responseFormateado = responseFormateado += '</select>';
    responseFormateado = responseFormateado.replaceAll(new RegExp(r'\n'), "");
    responseFormateado = responseFormateado.replaceAll(new RegExp(r'\r'), "");
    await Operaciones()
        .retornarCodigoPlan(responseFormateado)
        .then((List<String> codigosPlan) {
      codigosPlan.forEach((String codigo) async {
        await FirebaseDatabase.instance
            .reference()
            .child(
                'Pensums/Codigos de Planes de Estudio/${carrera.getFacultad()}_${carrera.getCodigo()}_$codigo')
            .set({
          'Facultad': '${carrera.getFacultad()}',
          'Carrera': '${carrera.getCodigo()}',
          'Plan': '$codigo'
        });
      });
    }).catchError((e) {
      print(e.toString());
    });
  });
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
  var response = await http
      .get('https://portalestudiantes.unanleon.edu.ni/pensum_academico.php');
  if (response.statusCode == 200) {
    await Operaciones()
        .extraerCodigosFacultad(response.body.toString())
        .then((onValue) async {
      await Operaciones().extraerCodigosPlanes('0', '0').then((planes) async {
        await Operaciones().extraerPlanes().then((onValues) async {
          await Operaciones().pasarDatosDeFirestoreAlRealtimeDatabase();
        }).catchError((e) {
          print(e.toString());
        });
      }).catchError((e) {
        print(e.toString());
      });
    }).catchError((e) {
      print(e.toString());
    });
    return 'Hecho';
  }
}

/*Future<Widget> realizarPeticiones(DataSnapshot snapshot) async {
  Clase clase = new Clase();
  clase.setCarrera(snapshot.value['Carrera'].toString());
  clase.setFacultad(snapshot.value['Facultad'].toString());
  await http.post(
      'https://portalestudiantes.unanleon.edu.ni/funciones.php?npage=2',
      body: {
        'carrera': '${snapshot.value['Carrera']}'
      }).then((http.Response response) {
    clase.setResponse(response.body.toString());
    peticionesParaPlanes.add(clase);
  }).catchError((e) {
    print(e.toString());
  });
  contador += 1;
  if (contador == 183) {
    recorrerLista();
    return Text('');
  }
}*/

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

  _onEntryAddedCarrera(Event event) {
    setState(() {
      peticionesParaPlanes.clear();
      peticionesParaPlanes.add(Carrera.fromSnapshot(event.snapshot));
      peticionesParaPlanes.forEach((Carrera carrera) {
        recorrerLista();
      });
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
            body: new RouterPage(
          servicio: new Servicio(
            isAndroid: this.widget.isAndroid,
          ),
          isAndroid: this.widget.isAndroid,
        )
            /*FirebaseAnimatedList(
                query: FirebaseDatabase.instance
                    .reference()
                    .child('CodigosDePlanesDeEstudioCompletos'),
                itemBuilder: (context, snapshot, animation, index) {
                  return FutureBuilder<Widget>(
                    future: realizarPeticiones(snapshot),
                    builder: (context, response) {
                      if (response.hasData) {
                        return ListTile(
                          title: Text(
                            snapshot.value['Carrera'],
                            style: TextStyle(
                              fontFamily: 'SanFrancisco',
                              color: Colors.black,
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Text(
                              snapshot.value['Facultad'],
                              style: TextStyle(
                                fontFamily: 'SanFrancisco',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          trailing: Text(
                            snapshot.value['Plan'],
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'SanFrancisco',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Text('');
                    },
                  );
                })*/
            /*FutureBuilder<dynamic>(
          future: extraerPentsum(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[Text(snapshot.data.toString())],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        )*/
            /*FutureBuilder<List<dynamic>>(
            future: extraerPentsum(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext ctx, int index) {
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
