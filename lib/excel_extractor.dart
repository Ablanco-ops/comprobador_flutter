import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

import 'common.dart';
import 'modelo/entrada_datos.dart';
import 'modelo/modelo_datos.dart';

List<EntradaDatos> leerExcel(File path, ModeloDatos modelo) {
  List<EntradaDatos> listaEntradas = [];

  var bytes = path.readAsBytesSync();
  Excel excel = Excel.decodeBytes(bytes);
  Sheet hoja = excel[modelo.sheet];
  String fecha = '';
  bool datosCorrectos = true;
  for (String valor in modelo.comprobante.keys){
    if (hoja.cell(CellIndex.indexByString(valor)).value != modelo.comprobante[valor]){
      return listaEntradas;
    }
  }

  for (int i = modelo.primeraFila; i <= hoja.maxRows; i++) {
    if (hoja
            .cell(CellIndex.indexByString(modelo.idColumna + i.toString()))
            .value !=
        null) {
      String id = hoja
          .cell(CellIndex.indexByString(modelo.idColumna + i.toString()))
          .value;
      if (hoja
              .cell(CellIndex.indexByString(modelo.fecha + i.toString()))
              .value !=
          null) {
        fecha = hoja
            .cell(CellIndex.indexByString(modelo.fecha + i.toString()))
            .value
            .toString();
      }
      String cantidad = hoja
          .cell(CellIndex.indexByString(modelo.cantidadColumna + i.toString()))
          .value
          .toString();
      if (kDebugMode) {
        print(fecha + '|' + id + '|' + cantidad);
      }
      if (listaEntradas.any((element) => element.identificador == id)) {
        var entrada =
            listaEntradas.firstWhere((element) => element.identificador == id);
        entrada.cantidad =
            toPrecision(2, entrada.cantidad + double.parse(cantidad));
      } else {
        listaEntradas.add(EntradaDatos(
            identificador: id,
            cantidad: double.parse(cantidad),
            modelo: modelo.nombre,
            fecha: fecha));
      }
    }
  }
  return listaEntradas;
}
