import 'dart:io';

import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/excepciones.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:collection/collection.dart';
import 'modelo/entrada_datos.dart';

class ExportarExcel {
  static crearExcel(
      List<EntradaDatos> listaEntradas1,
      List<EntradaDatos> listaEntradas2,
      String modelo1,
      String modelo2,
      String path,
      Filtro filtro,
      BuildContext context) {
    Workbook workbook = Workbook();
    Worksheet hoja = workbook.worksheets[0];

    List<EntradaDatos> listaTotal = [...listaEntradas1];
    for (EntradaDatos entrada in listaEntradas2) {
      if (!listaTotal.any((element) =>
          element.identificador == entrada.identificador &&
          element.codProducto == entrada.codProducto)) {
        listaTotal.add(entrada);
      }
    }
    listaTotal.sort((a, b) => a.identificador.compareTo(b.identificador));

    final DateTime fechaRaw = DateTime.now();
    final fecha = DateFormat('dd-MM-yyyy').format(fechaRaw);

    String colorEncontrado = '#00CC00';
    String colorIncorrecto = '#FF0000';

    // Style estiloNoEncontrado = workbook.styles.addStyle(style)
    hoja.getRangeByName('A1:E1').merge();
    hoja.getRangeByName('A1').setText('Datos punteados $modelo1 - $modelo2');
    hoja.getRangeByName('A1').cellStyle.fontSize = 18;
    hoja.getRangeByName('A2').setDateTime(DateTime.now());
    hoja.getRangeByName('B2:D2').merge();
    hoja.getRangeByName('B2').setText('Filtro: ${filtro.name}');
    hoja.getRangeByName('A2:B2').cellStyle.bold = true;
    hoja.getRangeByName('B2').cellStyle.hAlign = HAlignType.center;
    hoja.getRangeByName('B4').setText('Fecha');
    hoja.getRangeByName('C4').setText('Identificador');
    hoja.getRangeByName('D4').setText('Código de producto');
    hoja.getRangeByName('E4').setText('Cantidad Modelo 1');
    hoja.getRangeByName('F4').setText('Cantidad Modelo 2');
    hoja.getRangeByName('B4:F4').cellStyle.borders.bottom.lineStyle =
        LineStyle.thick;
    hoja.getRangeByName('B4:F4').cellStyle.fontSize = 12;
    hoja.getRangeByName('B4:F4').cellStyle.bold = true;

    int index = 5;
    for (EntradaDatos entrada in listaTotal) {
      var color = '#FFFFFF';
      if (entrada.encontrado == Filtro.correcto) {
        color = colorEncontrado;
      }
      if (entrada.encontrado == Filtro.incorrecto) {
        color = colorIncorrecto;
      }
      hoja.getRangeByName('B$index').setText(entrada.fecha);
      hoja.getRangeByName('C$index').setText(entrada.identificador);
      hoja.getRangeByName('E$index').setNumber(entrada.cantidad);
      if (entrada.codProducto != null) {
        hoja.getRangeByName('D$index').setText(entrada.codProducto);
      }

      EntradaDatos? entrada2 = listaEntradas2.firstWhereOrNull(
          (element) => entrada.identificador == element.identificador);

      if (entrada2 != null && entrada.modelo != entrada2.modelo) {
        hoja.getRangeByName('F$index').setNumber(entrada2.cantidad);
        hoja.getRangeByName('F$index').cellStyle.backColor = color;
      }

      hoja.getRangeByName('E$index').cellStyle.backColor = color;
      index++;
    }
    for (int i = 1; i < 8; i++) {
      hoja.autoFitColumn(i);
    }
    Range rangoDatos = hoja.getRangeByName('B4:F$index');
    rangoDatos.cellStyle.borders.all.lineStyle = LineStyle.thin;
    hoja.getRangeByName('B4:B$index').cellStyle.borders.left.lineStyle =
        LineStyle.thick;
    hoja.getRangeByName('F4:F$index').cellStyle.borders.right.lineStyle =
        LineStyle.thick;
    hoja.getRangeByName('B$index:F$index').cellStyle.borders.right.lineStyle =
        LineStyle.thick;
    hoja.getRangeByName('B4:F4').cellStyle.borders.all.lineStyle =
        LineStyle.thick;

    try {
      final List<int> bytes = workbook.saveAsStream();
      File(path + '/${modelo1}_$filtro-$fecha.xlsx').writeAsBytes(bytes);
      workbook.dispose();
    } catch (e) {
      mostrarError(TipoError.escrituraExcel, context);
    }
  }
}
