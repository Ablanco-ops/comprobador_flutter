import 'dart:convert';
import 'dart:io';

import 'package:comprobador_flutter/datos/almacen_datos.dart';
import 'package:comprobador_flutter/excepciones.dart';
import 'package:comprobador_flutter/extractor_datos/extractor.dart';
import 'package:comprobador_flutter/modelo/entrada_datos.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';
import '../modelo/archivo_datos.dart';

class CsvExtractor implements Extractor {
  final File file;
  CsvExtractor(this.file);
  List<List<dynamic>> entradasRaw = [];
  late ArchivoDatos _archivoDatos;

  @override
  List<EntradaDatos> procesarArchivo(BuildContext context) {
    if (getArchivoDatos(context)) {
      return leerArchivo(context);
    } else {
      return [];
    }
  }

  @override
  bool getArchivoDatos(BuildContext context) {
    bool encontrado = false;
    try {
      final raw = const Utf8Decoder(allowMalformed: true)
          .convert(file.readAsBytesSync())
          .replaceAll('�', '');
      print(raw);
      entradasRaw =
          const CsvToListConverter().convert(raw, fieldDelimiter: ';');
      for (ArchivoDatos archivo in AlmacenDatos.listaArchivos) {
        if (entradasRaw[0][0].contains(archivo.listaHojas.first)) {
          _archivoDatos = archivo;
          encontrado = true;
        }
      }
    } catch (e) {
      mostrarError(TipoError.lecturaExcel, context);
    }
    return encontrado;
  }

  @override
  List<EntradaDatos> leerArchivo(BuildContext context) {
    List<EntradaDatos> listaEntradas = [];
    ModeloDatos modelo = AlmacenDatos.listaModelos.firstWhere(
        (element) => element.nombre == _archivoDatos.listaModelos[0]);
    int index = 0;
    for (List<dynamic> entrada in entradasRaw) {
      if (index >= modelo.primeraFila) {
        EntradaDatos? entradaExistente = listaEntradas.firstWhereOrNull(
            (element) =>
                element.ciudad == getCiudad(modelo, entrada) &&
                element.fecha == entrada[int.parse(modelo.fecha) - 1] &&
                element.codProducto ==
                    entrada[int.parse(modelo.codProductoColumna!) - 1]
                        .toString());
        if (entradaExistente == null) {
          listaEntradas.add(EntradaDatos(
              identificador:
                  entrada[int.parse(modelo.idColumna) - 1].toString(),
              ciudad: modelo.ciudad == null ? null : getCiudad(modelo, entrada),
              codProducto: modelo.codProducto == null
                  ? null
                  : entrada[int.parse(modelo.codProductoColumna!) - 1]
                      .toString(),
              cantidad:
                  entrada[int.parse(modelo.cantidadColumna) - 1].toDouble(),
              modelo: modelo.nombre,
              fecha: entrada[int.parse(modelo.fecha) - 1]));
        } else {
          entradaExistente.cantidad +=
              entrada[int.parse(modelo.cantidadColumna) - 1].toDouble();
        }
      }
      index++;
    }
    return listaEntradas;
  }

  String getCiudad(ModeloDatos modelo, List<dynamic> entrada) {
    try {
      return modelo.dictCiudades![entrada[int.parse(modelo.ciudad!) - 1]]!;
    } catch (e) {
      if (!entrada[int.parse(modelo.ciudad!) - 1].contains('DEVO')) {}
      return entrada[int.parse(modelo.ciudad!) - 1];
    }
  }
}
