class Notas {
  int _PrimerParcial;
  int _SegundoParcial;
  int _TercerParcial;
  int _NotaFinal;
  int _SegundaConvocatoria;
  int _CursoVerano;
  int _Tutoria;

  Notas();

  // metodo para establecer la nota del primer parcial del componente
  void setPrimerParcial(int primerParcial) {
    this._PrimerParcial = primerParcial;
  }

  // metodo para establecer la nota del segundo parcial del componente
  void setSegundoParcial(int segundoParcial) {
    this._SegundoParcial = segundoParcial;
  }

  // metodo para establecer la nota del tercer parcial del componente
  void setTercerParcial(int tercerParcial) {
    this._TercerParcial = tercerParcial;
  }

  // metodo para establecer la nota final del componente
  void setNotaFinal(int notaFinal) {
    this._NotaFinal = notaFinal;
  }

  // metodo para establecer la nota de segunda convocatoria del componente
  void setSegundaConvocatoria(int segundaConvocatoria) {
    this._SegundaConvocatoria = segundaConvocatoria;
  }

  // metodo para establecer la nota de curso de verano del componente
  void setCursoVerano(int cursoVerano) {
    this._CursoVerano = cursoVerano;
  }

  // metodo para establecer la nota de tutoria del componente
  void setTutoria(int tutoria) {
    this._Tutoria = tutoria;
  }

  // metodo para retornar la nota del primer parcial del componente
  int getPrimerParcial() {
    return this._PrimerParcial;
  }

  // metodo para retornar la nota del segundo parcial del componente
  int getSegundoParcial() {
    return this._SegundoParcial;
  }

  // metodo para retornar la nota del tercer parcial del componente
  int getTercerParcial() {
    return this._TercerParcial;
  }

  // metodo para retornar la nota final del componente
  int getNotaFinal() {
    return this._NotaFinal;
  }

  // metodo para retornar la nota de segunda convocatoria del componente
  int getSegundaConvocatoria() {
    return this._SegundaConvocatoria;
  }

  // metodo para retornar la nota de curso de verano del componente
  int getCursoVerano() {
    return this._CursoVerano;
  }

  // metodo para retornar la nota de tutoria del componente
  int getTutoria() {
    return this._Tutoria;
  }
}
