import 'dart:io';

import 'package:comprobador_flutter/datos/almacen_datos.dart';
import 'package:comprobador_flutter/excepciones.dart';
import 'package:comprobador_flutter/extractor_datos/extractor.dart';
import 'package:comprobador_flutter/modelo/archivo_datos.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import '../common.dart';
import '../modelo/entrada_datos.dart';
import '../modelo/modelo_datos.dart';

class ExcelExtractor implements Extractor {
  final File _file;

  late Excel _excel;
  late ArchivoDatos _archivoDatos;

  ExcelExtractor(this._file);

  @override
  List<EntradaDatos> procesarArchivo(BuildContext context) {
    try {
      var bytes = _file.readAsBytesSync();
      _excel = Excel.decodeBytes(bytes);
    } catch (e) {
      mostrarError(TipoError.lecturaExcel, context);
    }

    if (getArchivoDatos(context)) {
      return leerArchivo(context);
    } else {
      return [];
    }
  }

  @override
  bool getArchivoDatos(BuildContext context) {
    Set<String> listaHojas = {};
    for (var hoja in _excel.tables.keys) {
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

  @override
  List<EntradaDatos> leerArchivo(BuildContext context) {
    List<EntradaDatos> listaEntradas = [];

    for (String nombreModelo in _archivoDatos.listaModelos) {
      ModeloDatos modelo = AlmacenDatos.listaModelos
          .firstWhere((element) => element.nombre == nombreModelo);
      Sheet hoja = _excel[modelo.sheet];
      if (kDebugMode) {
        print(modelo.nombre);
      }

      for (String valor in modelo.comprobante.keys) {
        if (hoja.cell(CellIndex.indexByString(valor)).value !=
            modelo.comprobante[valor]) {
          if (kDebugMode) {
            print('comprobante erroneo');
          }
          mostrarExcepcion(
              TipoExcepcion.datosIncorrectos, modelo.sheet, context);
          return listaEntradas;
        }
      }
      String? codProducto;
      String id = '';
      String fecha = '';
      double cantidad = 0;
      String? ciudad;

      for (int i = modelo.primeraFila; i <= hoja.maxRows; i++) {
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
        String cellId = hoja
            .cell(CellIndex.indexByString(modelo.idColumna + i.toString()))
            .value
            .toString();

        if (modelo.productos == null) {
          id = cellId;
          if (hoja
                  .cell(CellIndex.indexByString(modelo.fecha + i.toString()))
                  .value !=
              null) {
            fecha = hoja
                .cell(CellIndex.indexByString(modelo.fecha + i.toString()))
                .value
                .toString();
          }

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
            var entrada = listaEntradas.firstWhereOrNull((element) =>
                element.identificador == id &&
                element.codProducto == codProducto);
            if (entrada != null) {
              entrada.cantidad = toPrecision(2, entrada.cantidad + cantidad);
            } else {
              listaEntradas.add(EntradaDatos(
                  identificador: id,
                  codProducto: codProducto,
                  cantidad: toPrecision(2, cantidad),
                  modelo: modelo.nombre,
                  fecha: fecha));
            }
          }
        } else {
          if (RegExp(r'[0-3][0-9]\.[0-1][0-9]\.[0-9]{4}').hasMatch(cellId)) {
            print(cellId);
            fecha = cellId;
          } else if (cellId.contains('DIA') && !cellId.contains('DEVO')) {
            ciudad = cellId;
          } else if (cellId.contains('-')) {
            id = cellId;
            for (String columna in modelo.productos!.keys) {
              if (hoja
                      .cell(CellIndex.indexByString(
                          columna + i.toString()))
                      .value !=
                  null) {
                try {
                  cantidad = (hoja
                          .cell(CellIndex.indexByString(
                              columna + i.toString()))
                          .value)
                      .toDouble();
                } catch (e) {
                  mostrarExcepcion(TipoExcepcion.errorNumerico,
                      '${modelo.cantidadColumna}:$i', context);
                }
              
              var entrada = listaEntradas.firstWhereOrNull((element) =>
                  element.identificador == id &&
                  element.codProducto == codProducto);
              if (entrada != null) {
                entrada.cantidad = toPrecision(2, entrada.cantidad + cantidad);
              } else {
                listaEntradas.add(EntradaDatos(
                    identificador: id,
                    ciudad: ciudad,
                    codProducto: modelo.productos![columna],
                    cantidad: toPrecision(2, cantidad),
                    modelo: modelo.nombre,
                    fecha: fecha));
              }
            }
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
