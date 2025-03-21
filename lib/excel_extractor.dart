import 'dart:io';

import 'package:comprobador_flutter/datos/almacen_datos.dart';
import 'package:comprobador_flutter/excepciones.dart';
import 'package:comprobador_flutter/modelo/archivo_datos.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'common.dart';
import 'modelo/entrada_datos.dart';
import 'modelo/modelo_datos.dart';

class ExcelExtractor {
  final File _file;

  late Excel excel;
  late ArchivoDatos _archivoDatos;

  ExcelExtractor(this._file);

  List<EntradaDatos> procesarExcel(BuildContext context) {
    getExcel(context);
    if (getArchivo(context)) {
      return leerExcel(context);
    } else {
      return [];
    }
  }

  void getExcel(BuildContext context) {
    try {
      var bytes = _file.readAsBytesSync();
      excel = Excel.decodeBytes(bytes);
    } catch (e) {
      mostrarError(TipoError.lecturaExcel, context);
    }
  }

  bool getArchivo(BuildContext context) {
    Set<String> listaHojas = {};
    for (var hoja in excel.tables.keys) {
      if (kDebugMode) {
        print(hoja);
      }
      listaHojas.add(hoja);
    }
    bool encontrado = false;
    for (ArchivoDatos archivo in AlmacenDatos.listaArchivos) {
      if (listaHojas.containsAll(archivo.listaHojas)) {
        _archivoDatos = archivo;
        encontrado = true;
        if (kDebugMode) {
          print(_archivoDatos.nombre);
        }
        break;
      }
    }
    if (!encontrado) {
      mostrarExcepcion(TipoExcepcion.archivoIncorrecto, '', context);
    }
    return encontrado;
  }

  List<EntradaDatos> leerExcel(BuildContext context) {
    List<EntradaDatos> listaEntradas = [];

    for (String nombreModelo in _archivoDatos.listaModelos) {
      ModeloDatos modelo =
          AlmacenDatos.listaModelos.firstWhere((element) => element.nombre == nombreModelo);
      Sheet hoja = excel[modelo.sheet];
      if (kDebugMode) {
        print(modelo.nombre);
      }
      String fecha = '';
      for (String valor in modelo.comprobante.keys) {
        if (hoja.cell(CellIndex.indexByString(valor)).value !=
            modelo.comprobante[valor]) {
          if (kDebugMode) {
            print('comprobante rroneo');
          }
          mostrarExcepcion(
              TipoExcepcion.datosIncorrectos, modelo.sheet, context);
          return listaEntradas;
        }
      }

      for (int i = modelo.primeraFila; i <= hoja.maxRows; i++) {
        String? codProducto;
        if (modelo.codProducto != null) {
          codProducto = modelo.codProducto!;
        }
        if (modelo.codProductoColumna != null) {
          if (hoja
                  .cell(CellIndex.indexByString(
                      modelo.codProductoColumna! + i.toString()))
                  .value !=
              null) {
            codProducto = hoja
                .cell(CellIndex.indexByString(
                    modelo.codProductoColumna! + i.toString()))
                .value;
          }
        }
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
          double cantidad = 0;
          if (hoja
                  .cell(CellIndex.indexByString(
                      modelo.cantidadColumna + i.toString()))
                  .value !=
              null) {
            try {
              cantidad = (hoja
                      .cell(CellIndex.indexByString(
                          modelo.cantidadColumna + i.toString()))
                      .value)
                  .toDouble();
            } catch (e) {
              mostrarExcepcion(TipoExcepcion.errorNumerico,
                  '${modelo.cantidadColumna}:$i', context);
            }
          }

          // if (kDebugMode) {
          //   print(fecha + '|' + id + '|' + cantidad.toString());
          // }
          if (listaEntradas.any((element) =>
              element.identificador == id &&
              element.codProducto == codProducto)) {
            var entrada = listaEntradas
                .firstWhere((element) => element.identificador == id);
            entrada.cantidad = toPrecision(2, entrada.cantidad + cantidad);
          } else {
            if (codProducto == '') {
              listaEntradas.add(EntradaDatos(
                  identificador: id,
                  cantidad: toPrecision(2, cantidad),
                  modelo: modelo.nombre,
                  fecha: fecha));
            } else {
              listaEntradas.add(EntradaDatos(
                  identificador: id,
                  codProducto: codProducto,
                  cantidad: toPrecision(2, cantidad),
                  modelo: modelo.nombre,
                  fecha: fecha));
            }
          }
        }
      }
    }
    if (kDebugMode) {
      print('Entradas ${listaEntradas.length}');
    }
    return listaEntradas;
  }
}
