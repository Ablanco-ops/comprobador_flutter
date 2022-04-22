import 'dart:io';

import 'package:comprobador_flutter/csv_extractor.dart';
import 'package:comprobador_flutter/datos/almacen_datos.dart';
import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/exportar_excel.dart';
import 'package:comprobador_flutter/modelo/entrada_datos.dart';
import 'package:comprobador_flutter/pdf_extractor.dart';
import 'package:comprobador_flutter/datos/preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';

import '../common.dart';
import '../excel_extractor.dart';

// Proveedor de datos de la pantalla principal home_screendart
class DatosProvider extends ChangeNotifier {
  File _path1 = File('');
  File _path2 = File('');

  //lista de entradas total y filtrada de cada archivo
  List<EntradaDatos> _listaEntradas1 = [];
  List<EntradaDatos> _listaEntradas2 = [];
  List<EntradaDatos> _listaEntradas1Filtrado = [];
  List<EntradaDatos> _listaEntradas2Filtrado = [];

  int noEncontrados = 0;
  int correctos = 0;
  int incorrectos = 0;

  String tipoArchivo1 = 'Tipo de archivo';
  String tipoArchivo2 = 'Tipo de archivo';

  Filtro filtroDatos = Filtro.todo;

  String pathExcelExport = '';

  bool iniciado = false;

  //Crea una instancia de ExcelExtractor, saca las entradas de datos del excel y el tipo de archivo
  void obtenerDatos(int numWidget, TipoDatos tipoDatos, BuildContext context) {
    File path = numWidget == 1 ? _path1 : _path2;
    List<EntradaDatos> listaEntradas = [];
    if (tipoDatos == TipoDatos.csv) {
      leerCsv(path, context);
    } else {
      if (kDebugMode) {
        print('archivo excel $path');
      }
      ExcelExtractor extractor = ExcelExtractor(path);
      listaEntradas = extractor.procesarExcel(context);
      var archivoDatos = AlmacenDatos.listaArchivos.firstWhere((archivo) {
        return archivo.listaModelos
            .any((modelo) => modelo == listaEntradas[0].modelo);
      });
      numWidget == 1
          ? tipoArchivo1 = archivoDatos.nombre
          : tipoArchivo2 = archivoDatos.nombre;
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

  void buscarEntradas(String busqueda) {
    filtrarDatos(filtroDatos);
    _listaEntradas1Filtrado
        .retainWhere((element) => element.identificador.contains(busqueda));
    _listaEntradas2Filtrado
        .retainWhere((element) => element.identificador.contains(busqueda));
    notifyListeners();
  }

  void filtrarDatos(Filtro filtro) {
    filtroDatos = filtro;
    _listaEntradas1Filtrado = _filtrarEntradas(_listaEntradas1);
    _listaEntradas2Filtrado = _filtrarEntradas(_listaEntradas2);
    notifyListeners();
  }

  List<EntradaDatos> _filtrarEntradas(List<EntradaDatos> lista) {
    List<EntradaDatos> listaFiltrada = [];
    listaFiltrada.addAll(lista);

    switch (filtroDatos) {
      case Filtro.noEncontrado:
        listaFiltrada.retainWhere(
            (element) => element.encontrado == Filtro.noEncontrado);
        break;
      case Filtro.correcto:
        listaFiltrada
            .retainWhere((element) => element.encontrado == Filtro.correcto);
        break;
      case Filtro.incorrecto:
        listaFiltrada
            .retainWhere((element) => element.encontrado == Filtro.incorrecto);
        break;
      default:
    }

    return listaFiltrada;
  }

  String filtroName(Filtro filtro) {
    switch (filtro) {
      case Filtro.correcto:
        return 'Correctos';
      case Filtro.incorrecto:
        return 'Incorrectos';
      case Filtro.noEncontrado:
        return 'No encontrados';
      default:
        return 'Todos';
    }
  }

  Future<void> seleccionarArchivo(int numWidget, BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx','csv']);
    if (result != null) {
      numWidget == 1
          ? _path1 = File(result.files.single.path!)
          : _path2 = File(result.files.single.path!);

      if (result.files.single.extension == 'csv') {
        obtenerDatos(numWidget, TipoDatos.csv, context);
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

  File getPath(int numWidget) {
    if (numWidget == 1) {
      return _path1;
    } else {
      return _path2;
    }
  }

  void cruzarDatos(BuildContext context) {
    if (_listaEntradas1.isEmpty || _listaEntradas2.isEmpty) {
      customSnack('No hay datos para comprobar', context);
    }
    // recorre la lista de entradas1 y por cada una busca la correspodiente en la lista2 con mismo id y codigo,
    // luego compara los entradas y las clasificas en correctas e incorrectas
    for (EntradaDatos entrada in _listaEntradas1) {
      var match = _listaEntradas2.firstWhereOrNull((element) =>
          (element.identificador == entrada.identificador &&
              element.codProducto == entrada.codProducto));
      if (match != null) {
        if (entrada.cantidad.abs() == match.cantidad.abs()) {
          entrada.encontrado = Filtro.correcto;
          match.encontrado = Filtro.correcto;
        } else {
          entrada.encontrado = Filtro.incorrecto;
          match.encontrado = Filtro.incorrecto;
        }
      }

      noEncontrados = _listaEntradas1
              .where((element) => element.encontrado == Filtro.noEncontrado)
              .length +
          _listaEntradas2
              .where((element) => element.encontrado == Filtro.noEncontrado)
              .length;
      correctos = _listaEntradas1
          .where((element) => element.encontrado == Filtro.correcto)
          .length;
      incorrectos = _listaEntradas1
          .where((element) => element.encontrado == Filtro.incorrecto)
          .length;
      notifyListeners();
    }
  }

  void exportar(BuildContext context) {
    Preferences.getPathExcel().then((value) => pathExcelExport = value);

    if (pathExcelExport == '') {
      customSnack(
          'Seleccione el directorio de destino en configuracion', context);
    } else if (_listaEntradas1Filtrado.isEmpty ||
        _listaEntradas2Filtrado.isEmpty) {
      customSnack('No hay datos cargados', context);
    } else {
      ExportarExcel.crearExcel(_listaEntradas1Filtrado, _listaEntradas2Filtrado,
          tipoArchivo1, tipoArchivo2, pathExcelExport, filtroDatos, context);
      customSnack('Excel creado en: $pathExcelExport', context);
    }
  }
}
