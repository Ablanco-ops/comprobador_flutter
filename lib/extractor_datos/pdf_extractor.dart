import 'dart:convert';
import 'dart:io';

import 'package:comprobador_flutter/excepciones.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../common.dart';
import '../modelo/entrada_datos.dart';

List<EntradaDatos> leerPdf(File file, BuildContext context) {
  final reId = RegExp(r"[0-9]{2}-[0-9]{5}");
  final reFecha = RegExp(r'[0-3][0-9]\.[0-1][0-9]\.[0-9][0-9]');
  List<EntradaDatos> listaEntradas = [];
  String rawText = '';

  try {
    final PdfDocument document =
        PdfDocument(inputBytes: file.readAsBytesSync());
    rawText = PdfTextExtractor(document).extractText();
    document.dispose();
  } catch (e) {
    mostrarError(TipoError.extraerPdf, context);
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
