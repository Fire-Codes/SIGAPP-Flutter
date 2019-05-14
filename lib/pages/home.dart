import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sigapp/servicios/servicio.dart';

class HomePage extends StatefulWidget {
  HomePage({this.isAndroid, this.onCerrarSesion, this.servicio});
  final bool isAndroid;
  final VoidCallback onCerrarSesion;
  final BaseServicio servicio;
  @override
  _HomePageState createState() => _HomePageState();
}

Widget _retorno(
  bool isAndroid,
  BaseServicio servicio,
  VoidCallback onCerrarSesion,
  int selectedIndex,
) {
  return Scaffold(
    drawer: Drawer(),
    appBar: AppBar(
      title: Text(
        'Inicio',
      ),
    ),
    body: Center(
      child: Text(
        'Hola Mundo',
      ),
    ),
    bottomNavigationBar: isAndroid
        ? BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.collections_bookmark),
                title: Text('Calificaciones'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                title: Text('Pensum'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.multiline_chart),
                title: Text('Estadísticas'),
              ),
            ],
            selectedItemColor: Colors.red,
          )
        : CupertinoTabBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bookmark),
                title: Text('Calificaciones'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.book),
                title: Text('Pensum'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.multiline_chart),
                title: Text('Estadísticas'),
              ),
            ],
            activeColor: Colors.red,
          ),
  );
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
        platform: TargetPlatform.android,
        fontFamily: 'SanFrancisco',
      ),
      home: _retorno(this.widget.isAndroid, this.widget.servicio,
          this.widget.onCerrarSesion, this._selectedIndex),
    );
  }
}
