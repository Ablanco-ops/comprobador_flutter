import 'dart:io';

import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/excepciones.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:collection/collection.dart';
import 'modelo/entrada_datos.dart';

class ExportarExcel {
  final List<EntradaDatos> listaEntradas1;
  final List<EntradaDatos> listaEntradas2;
  final String modelo1;
  final String modelo2;
  final String path;
  final Filtro filtro;
  final BuildContext context;

  ExportarExcel(
      {required this.listaEntradas1,
      required this.listaEntradas2,
      required this.modelo1,
      required this.modelo2,
      required this.path,
      required this.filtro,
      required this.context});

  late Workbook _workbook;
  late Worksheet _hoja;
  final String _colorEncontrado = '#00CC00';
  final String _colorIncorrecto = '#FF0000';
  late String _fecha;

  void exportar() {
    _workbook = Workbook();
    _hoja = _workbook.worksheets[0];
    final DateTime fechaRaw = DateTime.now();
    _fecha = DateFormat('dd-MM-yyyy').format(fechaRaw);

    _crearExcelSimple();
    _salvarExcel();
  }

  void _salvarExcel() {
    try {
      final List<int> bytes = _workbook.saveAsStream();
      File(path + '/${modelo1}_$filtro-$_fecha.xlsx').writeAsBytes(bytes);
      _workbook.dispose();
    } catch (e) {
      mostrarError(TipoError.escrituraExcel, context);
    }
  }

  void _crearExcelSimple() {
    List<EntradaDatos> listaTotal = [...listaEntradas1];
    for (EntradaDatos entrada in listaEntradas2) {
      if (!listaTotal.any((element) =>
          element.identificador == entrada.identificador &&
          element.codProducto == entrada.codProducto)) {
        listaTotal.add(entrada);
      }
    }
    listaTotal.sort((a, b) => a.identificador.compareTo(b.identificador));

    // Style estiloNoEncontrado = workbook.styles.addStyle(style)
    _hoja.getRangeByName('A1:E1').merge();
    _hoja.getRangeByName('A1').setText('Datos punteados $modelo1 - $modelo2');
    _hoja.getRangeByName('A1').cellStyle.fontSize = 18;
    _hoja.getRangeByName('A2').setDateTime(DateTime.now());
    _hoja.getRangeByName('B2:D2').merge();
    _hoja.getRangeByName('B2').setText('Filtro: ${filtro.name}');
    _hoja.getRangeByName('A2:B2').cellStyle.bold = true;
    _hoja.getRangeByName('B2').cellStyle.hAlign = HAlignType.center;
    _hoja.getRangeByName('B4').setText('Fecha');
    _hoja.getRangeByName('C4').setText('Identificador');
    _hoja.getRangeByName('D4').setText('Código de producto');
    _hoja.getRangeByName('E4').setText('Cantidad Modelo 1');
    _hoja.getRangeByName('F4').setText('Cantidad Modelo 2');
    _hoja.getRangeByName('B4:F4').cellStyle.borders.bottom.lineStyle =
        LineStyle.thick;
    _hoja.getRangeByName('B4:F4').cellStyle.fontSize = 12;
    _hoja.getRangeByName('B4:F4').cellStyle.bold = true;

    int index = 5;
    for (EntradaDatos entrada in listaTotal) {
      var color = '#FFFFFF';
      if (entrada.encontrado == Filtro.correcto) {
        color = _colorEncontrado;
      }
      if (entrada.encontrado == Filtro.incorrecto) {
        color = _colorIncorrecto;
      }
      _hoja.getRangeByName('B$index').setText(entrada.fecha);
      _hoja.getRangeByName('C$index').setText(entrada.identificador);
      _hoja.getRangeByName('E$index').setNumber(entrada.cantidad);
      if (entrada.codProducto != null) {
        _hoja.getRangeByName('D$index').setText(entrada.codProducto);
      }

      EntradaDatos? entrada2 = listaEntradas2.firstWhereOrNull(
          (element) => entrada.identificador == element.identificador);

      if (entrada2 != null && entrada.modelo != entrada2.modelo) {
        _hoja.getRangeByName('F$index').setNumber(entrada2.cantidad);
        _hoja.getRangeByName('F$index').cellStyle.backColor = color;
      }

      _hoja.getRangeByName('E$index').cellStyle.backColor = color;
      index++;
    }
    for (int i = 1; i < 8; i++) {
      _hoja.autoFitColumn(i);
    }
    Range rangoDatos = _hoja.getRangeByName('B4:F$index');
    rangoDatos.cellStyle.borders.all.lineStyle = LineStyle.thin;
    _hoja.getRangeByName('B4:B$index').cellStyle.borders.left.lineStyle =
        LineStyle.thick;
    _hoja.getRangeByName('F4:F$index').cellStyle.borders.right.lineStyle =
        LineStyle.thick;
    _hoja.getRangeByName('B$index:F$index').cellStyle.borders.right.lineStyle =
        LineStyle.thick;
    _hoja.getRangeByName('B4:F4').cellStyle.borders.all.lineStyle =
        LineStyle.thick;
  }

  bool comprobarMultiple() {
    bool multiple = true;
    for (EntradaDatos entrada in listaEntradas1) {
      if (listaEntradas1
          .any((element) => element.identificador == entrada.identificador)) {
        multiple = false;
      }
    }
    return multiple;
  }
}
