import 'dart:convert';
import 'dart:io';
import 'package:comprobador_flutter/exportar_excel.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'common.dart';

import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/modelo/entrada_datos.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:excel/excel.dart';

class Datos extends ChangeNotifier {
  late File _path1;
  late File _path2;

  List<EntradaDatos> _listaEntradas1 = [];
  List<EntradaDatos> _listaEntradas2 = [];
  late ModeloDatos _modelo1;
  late ModeloDatos _modelo2;

  String nombreModelo1 = 'Modelo';
  String nombreModelo2 = 'Modelo';

  void obtenerDatos(int numWidget, TipoDatos tipoDatos) {
    File path = numWidget == 1 ? _path1 : _path2;
    ModeloDatos modelo = numWidget == 1 ? _modelo1 : _modelo2;
    List<EntradaDatos> listaEntradas = [];
    if (tipoDatos == TipoDatos.pdf) {
      listaEntradas = leerPdf(path);
    } else {
      listaEntradas = leerExcel(path, modelo);
    }
    for (EntradaDatos entrada in listaEntradas) {
      print(entrada.toString());
    }
    listaEntradas.sort((a, b) => a.identificador.compareTo(b.identificador));
    numWidget == 1
        ? _listaEntradas1 = listaEntradas
        : _listaEntradas2 = listaEntradas;
    notifyListeners();
  }

  Future<void> seleccionarArchivo(int numWidget) async {
    TipoDatos tipoDatos = TipoDatos.xlsx;
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'pdf']);
    if (result != null) {
      if (result.files.single.extension == 'pdf') {
        tipoDatos = TipoDatos.pdf;
      }
      numWidget == 1
          ? _path1 = File(result.files.single.path!)
          : _path2 = File(result.files.single.path!);
      obtenerDatos(numWidget, tipoDatos);
    }
  }

  void setModelo(int numWidget, ModeloDatos modelo) {
    if (numWidget == 1) {
      _modelo1 = modelo;
      nombreModelo1 = modelo.nombre;
    } else {
      _modelo2 = modelo;
      nombreModelo2 = modelo.nombre;
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

  ModeloDatos getModelo(numWidget) {
    if (numWidget == 1) {
      return _modelo1;
    } else {
      return _modelo2;
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
    ExportarExcel.crearExcel(_listaEntradas1,_listaEntradas2, nombreModelo1, nombreModelo2);
  }

  List<EntradaDatos> leerExcel(File path, ModeloDatos modelo) {
    List<EntradaDatos> listaEntradas = [];

    var bytes = path.readAsBytesSync();
    Excel excel = Excel.decodeBytes(bytes);
    Sheet hoja = excel[modelo.sheet];
    String fecha = '';

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
            .cell(
                CellIndex.indexByString(modelo.cantidadColumna + i.toString()))
            .value
            .toString();
        // print(fecha + '|' + id + '|' + cantidad);
        if (listaEntradas.any((element) => element.identificador == id)) {
          var entrada = listaEntradas
              .firstWhere((element) => element.identificador == id);
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

  List<EntradaDatos> leerPdf(File file) {
    final reId = RegExp(r"[0-9]{2}-[0-9]{5}");
    final reCantidad = RegExp(r'-[0,9]+');
    final reFecha = RegExp(r'[0-3][0-9]\.[0-1][0-9]\.[0-9][0-9]');
    List<EntradaDatos> listaEntradas = [];
    String rawText = '';

    try {
      final PdfDocument document =
          PdfDocument(inputBytes: file.readAsBytesSync());
      rawText = PdfTextExtractor(document).extractText();
      document.dispose();
    } catch (e) {
      print(e.toString());
    }

    List<String> listaPedidosRaw = rawText.split('0,00');
    listaPedidosRaw.retainWhere((element) => element.contains(reId));
    // List<List<String>> filteredListaPedidos = [];
    for (String pedidoRaw in listaPedidosRaw) {
      String id = reId.firstMatch(pedidoRaw)!.group(0)!;
      String fecha = reFecha.firstMatch(pedidoRaw)!.group(0)!;
      var listatotal = const LineSplitter().convert(pedidoRaw);
      double cantidad = 0;
      cantidad = double.parse(listatotal.last);
      if (listaEntradas.any((element) => element.identificador == id)) {
        var entrada =
            listaEntradas.firstWhere((element) => element.identificador == id);
        entrada.cantidad = toPrecision(2, entrada.cantidad + cantidad);
      } else {
        listaEntradas.add(EntradaDatos(
            identificador: id,
            cantidad: cantidad,
            modelo: 'CHEP pdf',
            fecha: fecha));
      }
    }
    
    return listaEntradas;
  }
}
