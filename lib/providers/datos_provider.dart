import 'dart:io';

import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/exportar_excel.dart';
import 'package:comprobador_flutter/modelo/archivo_datos.dart';
import 'package:comprobador_flutter/modelo/entrada_datos.dart';
import 'package:comprobador_flutter/pdf_extractor.dart';
import 'package:comprobador_flutter/preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../common.dart';
import '../excel_extractor.dart';

class Datos extends ChangeNotifier {
  File _path1 = File('');
  File _path2 = File('');

  List<EntradaDatos> _listaEntradas1 = [];
  List<EntradaDatos> _listaEntradas2 = [];
  List<EntradaDatos> _listaEntradas1Filtrado = [];
  List<EntradaDatos> _listaEntradas2Filtrado = [];
  late ArchivoDatos _archivo1;
  late ArchivoDatos _archivo2;

  String _nombreArchivo1 = 'Tipo de archivo';
  String _nombreArchivo2 = 'Tipo de archivo';

  String pathExcelExport = '';

  void obtenerDatos(int numWidget, TipoDatos tipoDatos, BuildContext context) {
    File path = numWidget == 1 ? _path1 : _path2;
    List<EntradaDatos> listaEntradas = [];
    notifyListeners();
    if (tipoDatos == TipoDatos.pdf) {
      listaEntradas.addAll(leerPdf(path, context));
    } else {
      if (kDebugMode) {
        print('archivo excel $path');
      }
      ExcelExtractor extractor = ExcelExtractor(path, context);
      listaEntradas = extractor.procesarExcel();
    }
    for (EntradaDatos entrada in listaEntradas) {
      if (kDebugMode) {
        print(entrada.toString());
      }
    }
    listaEntradas.sort((a, b) => a.identificador.compareTo(b.identificador));
    if (numWidget == 1) {
      _listaEntradas1 = listaEntradas;
      _listaEntradas1Filtrado = listaEntradas;
    } else {
      _listaEntradas2 = listaEntradas;
      _listaEntradas2Filtrado = listaEntradas;
    }
    notifyListeners();
  }

  void filtrarDatos(Encontrado filtro) {
    _listaEntradas1Filtrado = _filtrarEntradas(filtro, _listaEntradas1);
    _listaEntradas2Filtrado = _filtrarEntradas(filtro, _listaEntradas2);
    notifyListeners();
  }

  List<EntradaDatos> _filtrarEntradas(
      Encontrado filtro, List<EntradaDatos> lista) {
    List<EntradaDatos> listaFiltrada = [];
    listaFiltrada.addAll(lista);
    if (kDebugMode) {
      print('${_listaEntradas1.length} - ${_listaEntradas2.length}');
    }
    switch (filtro) {
      case Encontrado.noEncontrado:
        listaFiltrada.retainWhere(
            (element) => element.encontrado == Encontrado.noEncontrado);
        break;
      case Encontrado.correcto:
        listaFiltrada.retainWhere(
            (element) => element.encontrado == Encontrado.correcto);
        break;
      case Encontrado.incorrecto:
        listaFiltrada.retainWhere(
            (element) => element.encontrado == Encontrado.incorrecto);
        break;
      default:
    }
    if (kDebugMode) {
      print(listaFiltrada.length);
    }
    return listaFiltrada;
  }

  Future<void> seleccionarArchivo(int numWidget, BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'pdf']);
    if (result != null) {
      numWidget == 1
          ? _path1 = File(result.files.single.path!)
          : _path2 = File(result.files.single.path!);

      if (result.files.single.extension == 'pdf') {
        obtenerDatos(numWidget, TipoDatos.pdf, context);
      } else {
        obtenerDatos(numWidget, TipoDatos.xlsx, context);
      }
    }
    notifyListeners();
  }

  Future<void> seleccionarPathExcel() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      Preferences.setPathExcel(result);
      pathExcelExport = result;
    }
    notifyListeners();
  }

  void setArchivo(int numWidget, ArchivoDatos archivo) {
    if (numWidget == 1) {
      _archivo1 = archivo;
      _nombreArchivo1 = archivo.nombre;
    } else {
      _archivo2 = archivo;
      _nombreArchivo2 = archivo.nombre;
    }
    notifyListeners();
  }

  String getArchivo(int numWidget) {
    if (numWidget == 1) {
      return _nombreArchivo1;
    } else {
      return _nombreArchivo2;
    }
  }

  List<EntradaDatos> getListEntradas(int numWidget) {
    if (numWidget == 1) {
      return _listaEntradas1Filtrado;
    } else {
      return _listaEntradas2Filtrado;
    }
  }

  String getId(int numWidget, int index) {
    List<EntradaDatos> entradas =
        numWidget == 1 ? _listaEntradas1Filtrado : _listaEntradas2Filtrado;
    String id = entradas[index].identificador;
    String codProducto = '';
    if (entradas[index].codProducto != null) {
      codProducto = ' - ${entradas[index].codProducto}';
    }
    return '$id $codProducto';
  }

  ArchivoDatos getModelo(int numWidget) {
    if (numWidget == 1) {
      return _archivo1;
    } else {
      return _archivo2;
    }
  }

  File getPath(int numWidget) {
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

  void exportar(BuildContext context) {
    // ExportarExcel.exceltest();
    Preferences.getPathExcel().then((value) => pathExcelExport = value);
    if (pathExcelExport != '') {
      ExportarExcel.crearExcel(_listaEntradas1Filtrado, _listaEntradas2Filtrado,
          _nombreArchivo1, _nombreArchivo2, pathExcelExport);
      customSnack('Excel creado en: $pathExcelExport', context);
    } else {
      customSnack(
          'Seleccione el directorio de destino en configuracion', context);
    }
  }
}
