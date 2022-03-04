import 'dart:io';

import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/exportar_excel.dart';
import 'package:comprobador_flutter/modelo/archivo_datos.dart';
import 'package:comprobador_flutter/modelo/entrada_datos.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:comprobador_flutter/pdf_extractor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'common.dart';
import 'excel_extractor.dart';

class Datos extends ChangeNotifier {
  File _path1 = File('');
  File _path2 = File('');

  List<EntradaDatos> _listaEntradas1 = [];
  List<EntradaDatos> _listaEntradas2 = [];
  late ArchivoDatos _archivo1;
  late ArchivoDatos _archivo2;

  String nombreArchivo1 = 'Modelo';
  String nombreArchivo2 = 'Modelo';

  void obtenerDatos(int numWidget) {
    File path = numWidget == 1 ? _path1 : _path2;
    ArchivoDatos archivo = numWidget == 1 ? _archivo1 : _archivo2;
    List<EntradaDatos> listaEntradas = [];
    if (archivo.formato == TipoDatos.pdf) {
      listaEntradas.addAll(leerPdf(path));
    } else {
      print('archivo excel $path');
      for (ModeloDatos modelo in archivo.listaModelos){
        listaEntradas.addAll(leerExcel(path, modelo));
      }
      
    }
    for (EntradaDatos entrada in listaEntradas) {
      if (kDebugMode) {
        print(entrada.toString());
      }
    }
    listaEntradas.sort((a, b) => a.identificador.compareTo(b.identificador));
    numWidget == 1
        ? _listaEntradas1 = listaEntradas
        : _listaEntradas2 = listaEntradas;
    notifyListeners();
  }

  Future<void> seleccionarArchivo(int numWidget) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'pdf']);
    if (result != null) {
      numWidget == 1
          ? _path1 = File(result.files.single.path!)
          : _path2 = File(result.files.single.path!);
      obtenerDatos(numWidget);
    }
    notifyListeners();
  }

  void setArchivo(int numWidget, ArchivoDatos archivo) {
    if (numWidget == 1) {
      _archivo1 = archivo;
      nombreArchivo1 = archivo.nombre;
    } else {
      _archivo2 = archivo;
      nombreArchivo2 = archivo.nombre;
    }
    notifyListeners();
  }

  List<EntradaDatos> getListEntradas(numWidget) {
    if (numWidget == 1) {
      return _listaEntradas1;
    } else {
      return _listaEntradas2;
    }
  }

  ArchivoDatos getModelo(numWidget) {
    if (numWidget == 1) {
      return _archivo1;
    } else {
      return _archivo2;
    }
  }

  File getPath(numWidget) {
    if (numWidget == 1) {
      return _path1;
    } else {
      return _path2;
    }
  }

  void cruzarDatos() {
    for (EntradaDatos entrada in _listaEntradas1) {
      if (_listaEntradas2
          .any((element) => element.identificador == entrada.identificador)) {
        var match = _listaEntradas2.firstWhere(
            (element) => element.identificador == entrada.identificador);
        if (entrada.cantidad.abs() == match.cantidad.abs()) {
          entrada.encontrado = Encontrado.correcto;
          match.encontrado = Encontrado.correcto;
        } else {
          entrada.encontrado = Encontrado.incorrecto;
          match.encontrado = Encontrado.incorrecto;
        }
        notifyListeners();
      }
    }
  }

  void exportar() {
    // ExportarExcel.exceltest();
    ExportarExcel.crearExcel(
        _listaEntradas1, _listaEntradas2, nombreArchivo1, nombreArchivo2);
  }
}
