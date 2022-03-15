import 'dart:io';

import 'package:comprobador_flutter/common.dart';
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
      String path) {
    Workbook workbook = Workbook();
    Worksheet hoja = workbook.worksheets[0];

    final DateTime fechaRaw = DateTime.now();
    final fecha = DateFormat('dd-MM-yyyy').format(fechaRaw);

    String colorEncontrado = '#00CC00';
    String colorIncorrecto = '#FF0000';

    // Style estiloNoEncontrado = workbook.styles.addStyle(style)

    hoja.getRangeByName('A1').setText('Datos punteados $modelo1 - $modelo2');
    hoja.getRangeByName('A2').setDateTime(DateTime.now());

    hoja.getRangeByName('B4').setText('Fecha');
    hoja.getRangeByName('C4').setText('Identificador');
    hoja.getRangeByName('D4').setText('Cantidad Modelo 1');
    hoja.getRangeByName('D5').setText('Cantidad Modelo 2');

    int index = 5;
    for (EntradaDatos entrada in listaEntradas1) {
      var color = '#FFFFFF';
      if (entrada.encontrado == Filtro.correcto) {
        color = colorEncontrado;
      }
      if (entrada.encontrado == Filtro.incorrecto) {
        color = colorIncorrecto;
      }
      hoja.getRangeByName('B$index').setText(entrada.fecha);
      hoja.getRangeByName('C$index').setText(entrada.identificador);
      hoja.getRangeByName('D$index').setNumber(entrada.cantidad);

      EntradaDatos? entrada2 = listaEntradas2.firstWhereOrNull(
          (element) => entrada.identificador == element.identificador);

      if (entrada2 != null) {
        hoja.getRangeByName('E$index').setNumber(entrada.cantidad);
        hoja.getRangeByName('E$index').cellStyle.backColor = color;
      }

      hoja.getRangeByName('D$index').cellStyle.backColor = color;
      index++;
    }

    final List<int> bytes = workbook.saveAsStream();
    File(path + '/${modelo1}_punteado-$fecha.xlsx').writeAsBytes(bytes);
    workbook.dispose();
  }
}
