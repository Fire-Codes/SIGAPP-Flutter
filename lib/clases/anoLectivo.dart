import 'componente.dart';

class AnoLectivo {
  List<Componente> _Componentes = new List<Componente>();
  Componente _AuxComponente;
  int _Lectivo;
  int _Ano;
  int _IndiceAcademico;

  AnoLectivo();

  // metodo para agregar un nuevo componente
  void setComponente(
    int primerParcial,
    int segundoParcial,
    int tercerParcial,
    int notaFinal,
    int segundaConvocatoria,
    int cursoVerano,
    int tutoria,
    String nombreComponente,
    String tipo,
    int ciclo,
    int creditos,
  ) {
    this._AuxComponente = new Componente();
    this._AuxComponente.setNotas(primerParcial, segundoParcial, tercerParcial,
        notaFinal, segundaConvocatoria, cursoVerano, tutoria);
    this._AuxComponente.setNombre(nombreComponente);
    this._AuxComponente.setTipo(tipo);
    this._AuxComponente.setCiclo(ciclo);
    this._AuxComponente.setCreditos(creditos);
    this._Componentes.add(this._AuxComponente);
  }
}
