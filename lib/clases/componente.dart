import 'notas.dart';

class Componente {
  String _Nombre;
  Notas _Notas;
  String _Tipo;
  int _Ciclo;
  int _Creditos;

  Componente();

  // metodo para establecer el nombre del componente
  void setNombre(String nombreComponente) {
    this._Nombre = nombreComponente;
  }

  // metodo para establecer las notas del componente
  void setNotas(int primerParcial, int segundoParcial, int tercerParcial,
      int notaFinal, int segundaConvocatoria, int cursoVerano, int tutoria) {
    this._Notas.setPrimerParcial(primerParcial);
    this._Notas.setSegundoParcial(segundoParcial);
    this._Notas.setTercerParcial(tercerParcial);
    this._Notas.setNotaFinal(notaFinal);
    this._Notas.setSegundaConvocatoria(segundaConvocatoria);
    this._Notas.setCursoVerano(cursoVerano);
    this._Notas.setTutoria(tutoria);
  }

  // metodo par establecer el tipo del componente
  void setTipo(String tipo) {
    this._Tipo = tipo;
  }

  // metodo para establecer el ciclo del componente
  void setCiclo(int ciclo) {
    this._Ciclo = ciclo;
  }

  // metodo para establecer los creditos del componente
  void setCreditos(int creditos) {
    this._Creditos = creditos;
  }

  // metodo para retornar el nombre del componente
  String getNombre() {
    return this._Nombre;
  }

  // metodo para retornar las notas del componente
  Notas getNotas() {
    return this._Notas;
  }

  // metodo para retornar el tipo del componente
  String getTipo() {
    return this._Tipo;
  }

  // metodo para retornar el ciclo del componente
  int getCiclo() {
    return this._Ciclo;
  }

  // metodo para retornar los creditos del componente
  int getCreditos() {
    return this._Creditos;
  }
}
