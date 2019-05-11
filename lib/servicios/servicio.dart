import 'package:firebase_database/firebase_database.dart';

abstract class BaseServicio {
  Future<void> subirTablaAlRealtimeDatabase(String tabla);
  Future<void> subirFCMToken(String token);
  Future<int> subirCodigoFacultad(int codigo, String nombre);
}

class Servicio implements BaseServicio {
  Servicio({this.isAndroid});
  // se declara una variable y se inicializa por parametro para determinar la plataforma en la que esta corriendo la aplicacion
  final bool isAndroid;
  final FirebaseDatabase db = new FirebaseDatabase();

  Future<void> subirTablaAlRealtimeDatabase(String tabla) async {
    await this.db.reference().update({'tabla': tabla}).then((onvalue) {
      print("Tabla Subida al realtime database");
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> subirFCMToken(String token) async {
    await this.db.reference().update({'fcmToken': token}).then((onvalue) {
      print("Se ha subido el fcm token correctamente a la base de datos");
    }).catchError((e) {
      print(e.toString());
    });
  }
  
  Future<int> subirCodigoFacultad(int codigo, String nombre) async {
    await this.db.reference().child('Codigos de Facultades/$nombre').set({
      'Nombre': nombre,
      'Codigo': codigo
    }).then((onValue){
      print('El codigo de la facultad: $nombre se ha subido correctamente');
    }).catchError((e){
      print(e.toString());
    });
    return codigo;
  }
}
