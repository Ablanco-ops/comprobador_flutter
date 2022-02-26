import 'dart:io';

import 'package:comprobador_flutter/common.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'modelo/entrada_datos.dart';

class ExportarExcel {
  static crearExcel(
      List<EntradaDatos> listaEntradas, String modelo1, String modelo2) {
    Workbook workbook = new Workbook();
    Worksheet hoja = workbook.worksheets[0];

    String colorEncontrado = '#00CC00';
    String colorIncorrecto = '#FF0000';

    // Style estiloNoEncontrado = workbook.styles.addStyle(style)

    hoja.getRangeByName('A1').setText('Datos punteados $modelo1 - $modelo2');
    hoja.getRangeByName('A2').setDateTime(DateTime.now());

    hoja.getRangeByName('B4').setText('Fecha');
    hoja.getRangeByName('C4').setText('Identificador');
    hoja.getRangeByName('D4').setText('Cantidad');

    int index = 5;
    for (EntradaDatos entrada in listaEntradas) {
      var color = '#FFFFFF';
      hoja.getRangeByName('B$index').setText(entrada.fecha);
      hoja.getRangeByName('C$index').setText(entrada.identificador);
      hoja.getRangeByName('D$index').setNumber(entrada.cantidad);
      if (entrada.encontrado == Encontrado.correcto) {
        color = colorEncontrado;
      }
      if (entrada.encontrado == Encontrado.incorrecto) {
        color = colorIncorrecto;
      }
      hoja.getRangeByName('B$index').cellStyle.backColor = color;
      hoja.getRangeByName('C$index').cellStyle.backColor = color;
      hoja.getRangeByName('D$index').cellStyle.backColor = color;
      index++;
    }

    final List<int> bytes = workbook.saveAsStream();
    File('PunteoExportado.xlsx').writeAsBytes(bytes);
    workbook.dispose();
  }

  static exceltest() {
    // Create a new Excel document.
    final Workbook workbook = new Workbook();
//Accessing worksheet via index.
    final Worksheet sheet = workbook.worksheets[0];
//Add Text.
    sheet.getRangeByName('A1').setText('Hello World');
//Add Number
    sheet.getRangeByName('A3').setNumber(44);
//Add DateTime
    sheet.getRangeByName('A5').setDateTime(DateTime(2020, 12, 12, 1, 10, 20));
// Save the document.
    final List<int> bytes = workbook.saveAsStream();
    File('AddingTextNumberDateTime.xlsx').writeAsBytes(bytes);
//Dispose the workbook.
    workbook.dispose();
  }

  // static void crearExcel(
  //     List<EntradaDatos> listaEntradas, String modelo1, String modelo2) {
  //   Excel excel = Excel.createExcel();
  //   Sheet hoja = excel['Hoja'];

  //   CellStyle tituloStyle = CellStyle(fontSize: 12, bold: true);

  //   var titulo = hoja.cell(CellIndex.indexByString('A1'));
  //   titulo.value = 'Datos punteados $modelo1 - $modelo2';
  //   titulo.cellStyle = tituloStyle;

  //   var subtitulo = hoja.cell(CellIndex.indexByString('A2'));
  // }
}
