import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:html/dom.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth {
  Future<String> retornarTabla(String responseBody);
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

  Future<String> retornarTabla(String responseBody) async {
    final contenido = parse(responseBody);
    var anadirCabeceras = contenido.createElement(
        "thead><tr><th>Componentes</th><th>I Parcial</th><th>II Parcial</th><th>III Parcial</th><th>Nota Final</th><th>Segunda Convocatoria</th><th>Curso de Verano</th><th>Tutoria</th></tr></thead");

    // se crea la cabecera de thead
    anadirCabeceras = contenido.createElement('thead');
    // se crea el tr de la cabecera
    var tr = contenido.createElement('tr');

    // Componentes
    var th = contenido.createElement('th');
    var thTxt = contenido.createElement("Componentes");
    th.append(thTxt);
    tr.append(th);

    // I parcial
    th = contenido.createElement('th');
    thTxt = contenido.createElement('I Parcial');
    th.append(thTxt);
    tr.append(th);

    // II Parcial
    th = contenido.createElement('th');
    thTxt = contenido.createElement('II Parcial');
    th.append(thTxt);
    tr.append(th);

    // III Parcial
    th = contenido.createElement('th');
    thTxt = contenido.createElement('III Parcial');
    th.append(thTxt);
    tr.append(th);

    // Nota Final
    th = contenido.createElement('th');
    thTxt = contenido.createElement('Nota Final');
    th.append(thTxt);
    tr.append(th);

    // Segunda Convocatoria
    th = contenido.createElement('th');
    thTxt = contenido.createElement('Segunda Convocatoria');
    th.append(thTxt);
    tr.append(th);

    // Curso de Verano
    th = contenido.createElement('th');
    thTxt = contenido.createElement('Curso de Verano');
    th.append(thTxt);
    tr.append(th);

    // Tutoria
    th = contenido.createElement('th');
    thTxt = contenido.createElement('Tutoria');
    th.append(thTxt);
    tr.append(th);

    // se agrega el tr anterior a la cabecera inicial
    anadirCabeceras.append(tr);

    // se selecciona la tabla
    var parseTabla = contenido
        .querySelector('body > table > tbody > tr > td > form > table');

    // se leen las filas
    int filas = parseTabla.querySelector('tbody').children.length - 1;

    // se leen las columnas
    int columnas = anadirCabeceras.querySelector('tr').children.length;

    // se inserta la cabecera ya formateada
    parseTabla.insertBefore(anadirCabeceras, parseTabla.nodes[0]);

    var tabla = parseTabla.outerHtml.toString();

    // se elimina la anterior thead
    tabla = tabla.replaceAll(
        new RegExp(
            r'<tr><td bgcolor="#c7d3ea" align="center"><font size="2"><b>COMPONENTES</b></font></td><td bgcolor="#c7d3ea" align="center"><font size="2"><b>I PARCIAL</b></font></td><td bgcolor="#c7d3ea" align="center"><font size="2"><b>II PARCIAL</b></font></td><td bgcolor="#c7d3ea" align="center"><font size="2"><b>III PARCIAL</b></font></td><td bgcolor="#c7d3ea" align="center"><font size="2"><b>N.FINAL</b></font></td><td bgcolor="#c7d3ea" align="center"><font size="2"><b>SEGUNDA CONVOCATORIA</b></font></td><td bgcolor="#c7d3ea" align="center"><font size="2"><b>CURSO DE VERANO</b></font></td><td bgcolor="#c7d3ea" align="center"><font size="2"><b>TUTORIA</b></font></td></tr>'),
        '');

    // se comienza a eliminar el codigo de diseño de la tabla para dejarla en texto plano
    tabla = tabla.replaceAll(
        new RegExp(
            r' align="center" border="1" cellpadding="0" cellspacing="0" color="black" width="90%"'),
        '');
    tabla = tabla.replaceAll(new RegExp(r' border="1"'), '');
    tabla =
        tabla.replaceAll(new RegExp(r' bgcolor="#c7d3ea" align="center"'), '');
    tabla = tabla.replaceAll(new RegExp(r'<font size="2"><b>'), '');
    tabla = tabla.replaceAll(new RegExp(r'</b></font>'), '');
    tabla = tabla.replaceAll(new RegExp(r'<font size="2">'), '');
    tabla = tabla.replaceAll(new RegExp(r'</font>'), '');
    tabla = tabla.replaceAll(new RegExp(r' align="center"'), '');
    tabla = tabla.replaceAll(new RegExp(r'&nbsp;'), '');
    tabla = tabla.replaceAll(new RegExp(r' colspan="8"'), '');
    tabla = tabla.replaceAll(new RegExp(r'<b>'), '');
    tabla = tabla.replaceAll(new RegExp(r'</b>'), '');
    tabla = tabla.replaceAll(new RegExp(r'<font>'), '');
    tabla = tabla.replaceAll(new RegExp(r'<td></td>'), "<td>-</td>");
    tabla = tabla.replaceAll(
        new RegExp(r'<Componentes></Componentes>'), 'Componentes');
    tabla =
        tabla.replaceAll(new RegExp(r'<I Parcial></I Parcial>'), 'I Parcial');
    tabla = tabla.replaceAll(
        new RegExp(r'<II Parcial></II Parcial>'), 'II Parcial');
    tabla = tabla.replaceAll(
        new RegExp(r'<III Parcial></III Parcial>'), 'III Parcial');
    tabla = tabla.replaceAll(
        new RegExp(r'<Nota Final></Nota Final>'), 'Nota Final');
    tabla = tabla.replaceAll(
        new RegExp(r'<Segunda Convocatoria></Segunda Convocatoria>'),
        'Segunda Convocatoria');
    tabla = tabla.replaceAll(
        new RegExp(r'<Curso de Verano></Curso de Verano>'), 'Curso de Verano');
    tabla = tabla.replaceAll(new RegExp(r'<Tutoria></Tutoria>'), 'Tutoria');
    var tablita = parse(tabla.toString());
    await this.subirTablaAlRealtimeDatabase(tablita.outerHtml.toString());
    print("numero de filas: " +
        filas.toString() +
        "\nnumero de columnas:" +
        columnas.toString());
    return tablita.outerHtml.toString();
  }
}
