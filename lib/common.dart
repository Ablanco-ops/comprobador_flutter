import 'dart:io';

import 'package:flutter/material.dart';

double toPrecision(int fractionDigits, double numero) {
  return (double.parse((numero).toStringAsFixed(fractionDigits)));
}

enum Filtro { todo, noEncontrado, correcto, incorrecto }
enum TipoDatos { csv, xlsx }
enum CamposModelo {
  nombre,
  primeraFila,
  idColumna,
  codProductoColumna,
  codProducto,
  cantidadColumna,
  sheet,
  fecha,
  comprobante
}

const customPadding = EdgeInsets.all(8);

void customSnack(String texto, BuildContext context) {
  SnackBar snackBar = SnackBar(content: Text(texto));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

String getRoot() {
  final path = Platform.resolvedExecutable.replaceAll('comprobador.exe', '');
  return path;
}

Future<bool> customDialog(
    String title, String texto, BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(texto),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Si'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              )
            ],
          ));
}


