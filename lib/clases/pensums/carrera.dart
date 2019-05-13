import 'package:firebase_database/firebase_database.dart';

class Carrera {
  String _Key;
  String _Facultad;
  String _Codigo;
  String _Response;
  String _Nombre;

  Carrera();

  Carrera.fromSnapshot(DataSnapshot snapshot)
      : this._Key = snapshot.key,
        this._Facultad = snapshot.value['Facultad'],
        this._Codigo = snapshot.value['Codigo'],
        this._Response = snapshot.value['HTML'],
        this._Nombre = snapshot.value['Nombre'];

  toJson() {
    return {
      'Key': this._Key,
      'Nombre': this._Nombre,
      'Codigo': this._Codigo,
      'HTML': this._Response,
      'Facultad': this._Facultad
    };
  }

  void setFacultad(String facultad) {
    this._Facultad = facultad;
  }

  void setCodigo(String codigo) {
    this._Codigo = codigo;
  }

  void setResponse(String response) {
    this._Response = response;
  }

  void setNombre(String nombre) {
    this._Nombre = nombre;
  }

  String getNombre() {
    return this._Nombre;
  }

  String getFacultad() {
    return this._Facultad;
  }

  String getCodigo() {
    return this._Codigo;
  }

  String getResponse() {
    return this._Response;
  }

  String getKey(){
    return this._Key;

  }
}
