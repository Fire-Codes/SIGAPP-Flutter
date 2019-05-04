import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth {
  Future<void> subirTablaAlRealtimeDatabase(String tabla);
  Future<void> subirFCMToken(String token);
}

class Servicio implements BaseAuth {
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
}
