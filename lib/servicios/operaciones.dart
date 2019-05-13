import 'dart:async';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'servicio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sigapp/clases/pensums/carrera.dart';
import 'package:sigapp/clases/pensums/plan.dart';

abstract class BaseOperaciones {
  Future<String> retornarTabla(String responseBody);
  Future<void> extraerCodigosFacultad(String responseBody);
  Future<String> subirCodigosFacultad(Node tr);
  Future<List<Carrera>> extraerCodigosCarreras(String codigo);
  Future<List<String>> retornarCodigoPlan(String outerHtml);
  Future<List<Plan>> extraerCodigosPlanes(
      String codigoCarrera, String codigoFacultad);
  Future<void> extraerPlanes();
  Future<void> pasarDatosDeFirestoreAlRealtimeDatabase();
}

class Operaciones implements BaseOperaciones {
  List<Carrera> carreras = new List<Carrera>();
  List<Plan> planes = new List<Plan>();
  final servicio = new Servicio();
  int contadorCarreras = 0;
  int contadorFacultades = 0;
  int contadorPlanes = 0;
  final Firestore fs = Firestore.instance;

  final List<int> codFacultades = [19, 6, 22, 3, 2, 5, 1, 21, 24, 26, 4, 20, 0];
  final List<String> nombresFacultades = [
    'CIENCIAS AGRARIAS Y VETERINARIAS',
    'CIENCIAS DE LA EDUCACION',
    'CIENCIAS ECONOMICAS',
    'CIENCIAS JURIDICAS Y SOCIALES',
    'CIENCIAS MEDICAS',
    'CIENCIAS QUIMICAS',
    'CIENCIAS Y TECNOLOGIAS',
    'CUR-JINOTEGA',
    'CUR-SOMOTILLO',
    'DEPARTAMENTO DE EDUCACION VIRTUAL',
    'ODONTOLOGIA',
    'SEDE SOMOTO',
    'SEMESTRE DE ESTUDIOS GENERALES'
  ];

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
    await this
        .servicio
        .subirTablaAlRealtimeDatabase(tablita.outerHtml.toString());
    print("numero de filas: " +
        filas.toString() +
        "\nnumero de columnas:" +
        columnas.toString());
    return tablita.outerHtml.toString();
  }

  Future<String> extraerCodigosFacultad(String responseBody) async {
    // print("el dato pasado es: $responseBody}");
    responseBody = responseBody.replaceAll(new RegExp(r'\n'), "");
    responseBody = responseBody.replaceAll(new RegExp(r'\t'), "");
    responseBody = responseBody.replaceAll(new RegExp(r'\r'), "");
    //responseBody = responseBody.replaceAll(new RegExp(r'\/'), "");
    responseBody = responseBody.replaceAll(new RegExp(r'\"'), "");
    responseBody = responseBody.replaceRange(0, 11476, "");
    responseBody = responseBody.replaceRange(863, responseBody.length, "");
    print(responseBody.length.toString());
    var tabla = parse(responseBody);
    await this
        .servicio
        .subirTablaAlRealtimeDatabase(tabla.outerHtml.toString());
    var select = tabla.querySelector('body > select');
    int selectLenght = select.nodes.length;
    print("hay $selectLenght facultades");
    for (int i = 1; i <= codFacultades.length; i++) {
      subirCodigosFacultad(
              select.querySelector('body > select > option:nth-child($i)'))
          .then((codigo) {
        this.extraerCodigosCarreras(codigo.toString());
      }).catchError((e) {
        print(e.toString());
      });
    }
    return await select.outerHtml.toString();
  }

  Future<List<Carrera>> extraerCodigosCarreras(String codigo) async {
    Carrera carrera = new Carrera();
    await http.post(
      'https://portalestudiantes.unanleon.edu.ni/funciones.php?npage=1',
      body: {'facultad': '$codigo'},
    ).then((http.Response response) async {
      var selectFormateado = response.body.toString();
      selectFormateado = selectFormateado += '</select>';
      selectFormateado = selectFormateado.replaceAll(RegExp(r'\r'), "");
      selectFormateado = selectFormateado.replaceAll(RegExp(r'\n'), "");
      var selectHtml = await parse(selectFormateado);
      await selectHtml
          .querySelector('body > select')
          .children
          .forEach((carreraa) async {
        if (carreraa.attributes['value'].toString() == '-1' ||
            carreraa.outerHtml
                .toString()
                .contains('<option value="-1">No hay datos</option>')) {
          return;
        } else {
          carrera.setNombre(carreraa.text.toString());
          carrera.setFacultad(codigo.toString());
          carrera.setCodigo(carreraa.attributes['value'].toString());
          carrera.setResponse(selectHtml.outerHtml.toString());
          carreras.add(carrera);
          //print('Va por la carrera: ${carrera.getNombre()}');
          await this
              .fs
              .document(
                  'Pensums/Codigos de Carreras/CodigosCarreras/${carrera.getFacultad()}_${carrera.getCodigo()}')
              .setData({
            'Nombre': '${carrera.getNombre()}',
            'Carrera': '${carrera.getCodigo()}',
            'Facultad': '${carrera.getFacultad()}',
            'HTML': '${carrera.getResponse()}'
          }).then((onValue) async {
            /*await extraerCodigosPlanes(
                carrera.getCodigo(), carrera.getFacultad());*/
          }).catchError((e) {
            print(e.toString());
          });

          await FirebaseDatabase.instance
              .reference()
              .child(
                  'Pensums/Codigos de Carreras/${carrera.getFacultad()}_${carrera.getCodigo()}')
              .set({
                'Nombre': '${carrera.getNombre()}',
                'Carrera': '${carrera.getCodigo()}',
                'Facultad': '${carrera.getFacultad()}',
                'HTML': '${carrera.getResponse()}'
              })
              .then((onValue) async {})
              .catchError((e) {
                print(e.toString());
              });
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
    //print('Se formatearon y extrajeron ${carreras.length} carreras hasta el momento');
    return carreras;
  }

  Future<List<Plan>> extraerCodigosPlanes(
      String codigoCarrera, String codigoFacultad) async {
    fs
        .collection('Pensums/Codigos de Carreras/CodigosCarreras')
        .getDocuments()
        .then((QuerySnapshot carreras) {
      carreras.documents.forEach((DocumentSnapshot carrera) async {
        Plan plan = new Plan();
        await http.post(
          'https://portalestudiantes.unanleon.edu.ni/funciones.php?npage=2',
          body: {'carrera': '${carrera.data['Carrera']}'},
        ).then((http.Response response) async {
          var selectFormateado = response.body.toString();
          selectFormateado = selectFormateado += '</select>';
          selectFormateado = selectFormateado.replaceAll(RegExp(r'\r'), "");
          selectFormateado = selectFormateado.replaceAll(RegExp(r'\n'), "");
          var selectHtml = await parse(selectFormateado);
          await selectHtml
              .querySelector('body > select')
              .children
              .forEach((plann) async {
            //print('Plan ${plann.text}');
            if (plann.attributes['value'].toString() == '-1' ||
                plann.outerHtml
                    .toString()
                    .contains('<option value="-1">No hay datos</option>')) {
              return;
            } else {
              plan.setNombre(plann.text.toString());
              plan.setFacultad(carrera.data['Facultad'].toString());
              plan.setCodigo(plann.attributes['value'].toString());
              plan.setResponse(selectHtml.outerHtml.toString());
              plan.setCarrera(carrera.data['Carrera'].toString());
              planes.add(plan);
              await fs
                  .document(
                      'Pensums/Codigos de Planes de Estudio/CodigosPlanesDeEstudio/${plan.getFacultad()}_${plan.getCarrera()}_${plan.getCodigo()}')
                  .setData({
                'Nombre': '${plan.getNombre()}',
                'Plan': '${plan.getCodigo()}',
                'Facultad': '${plan.getFacultad()}',
                'HTML': '${plan.getResponse()}',
                'Carrera': '${plan.getCarrera()}'
              }).then((onValue) {
                //print('${plan.getCodigo()}: Hecho');
              }).catchError((e) {
                print(e.toString());
              });
              await FirebaseDatabase.instance
                  .reference()
                  .child(
                      'Pensums/Codigos de Planes de Estudio/${plan.getFacultad()}_${plan.getCarrera()}_${plan.getCodigo()}')
                  .set({
                'Nombre': '${plan.getNombre()}',
                'Plan': '${plan.getCodigo()}',
                'Facultad': '${plan.getFacultad()}',
                'HTML': '${plan.getResponse()}',
                'Carrera': '${plan.getCarrera()}'
              }).then((onValue) {
                //print('${plan.getCodigo()}: Hecho');
              }).catchError((e) {
                print(e.toString());
              });
            }
          });
        }).catchError((e) {
          print(e.toString());
        });
      });
    }).catchError((e) {
      print(e.toString());
    });
    /*print(
        'Se formatearon y extrajeron ${planes.length} planes de estudio hasta el momento');*/
    return planes;
  }

  Future<void> extraerPlanes() async {
    await fs
        .collection(
            '/Pensums/Codigos de Planes de Estudio/CodigosPlanesDeEstudio/')
        .getDocuments()
        .then((QuerySnapshot planes) {
      planes.documents.forEach((DocumentSnapshot plan) async {
        var response = await http.post(
          'https://portalestudiantes.unanleon.edu.ni/listar.php',
          body: {
            'facultad': '${plan.data['Facultad']}',
            'carrera': '${plan.data['Carrera']}',
            'plan': '${plan.data['Plan']}',
            'enviar': 'Visualizar'
          },
        );
        if (response.statusCode == 200) {
          var html = parse(response.body.toString());
          await fs
              .document(
                  '/Pensums/Planes de Estudio/ResponsesDePlanesDeEstudio/Plan_${plan.documentID}')
              .setData({
            'Cod_Facultad': '${plan.data['Facultad']}',
            'Cod_Carrera': '${plan.data['Carrera']}',
            'Cod_Plan': '${plan.data['Plan']}',
            'Response_Plan': '${html.outerHtml.toString()}'
          }).then((onValue) {
            //print('Plan ${plan.documentID} subido Correctamente');
          }).catchError((e) {
            print(e.toString());
          });
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> pasarDatosDeFirestoreAlRealtimeDatabase() async {
    await fs
        .collection('/Pensums/Planes de Estudio/ResponsesDePlanesDeEstudio/')
        .getDocuments()
        .then((QuerySnapshot responsePlanes) {
      responsePlanes.documents.forEach((DocumentSnapshot response) async {
        await FirebaseDatabase.instance
            .reference()
            .child('Pensums')
            .child('Response de Planes de Estudio')
            .child(response.documentID)
            .set(response.data);
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future<String> subirCodigosFacultad(Node tr) async {
    String codigo;
    String nombre;
    codigo = tr.attributes['value'].toString();
    nombre = tr.text.toString();
    //print(nombre + ": $codigo");
    await this.servicio.subirCodigoFacultad(codigo, nombre);
    return codigo.toString();
  }

  Future<List<String>> retornarCodigoPlan(String outerHtml) async {
    List<String> listaDeCodigosDePlan = new List<String>();
    var html = parse(outerHtml);
    var select = html.querySelector('body > select');
    select.children.forEach((plan) {
      if (plan.attributes['value'].toString().contains('-1') ||
          plan.outerHtml
              .toString()
              .contains('<option value="-1">No hay datos</option>')) {
      } else {
        listaDeCodigosDePlan.add(plan.attributes['value'].toString());
      }
    });
    return await listaDeCodigosDePlan;
  }
}
