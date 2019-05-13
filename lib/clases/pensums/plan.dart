class Plan {
  String _Facultad;
  String _Carrera;
  String _Codigo;
  String _Response;
  String _Nombre;

  Plan();

  void setFacultad(String facultad) {
    this._Facultad = facultad;
  }

  void setCarrera(String carrera) {
    this._Carrera = carrera;
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

  String getCarrera() {
    return this._Carrera;
  }

  String getCodigo() {
    return this._Codigo;
  }

  String getResponse() {
    return this._Response;
  }
}
