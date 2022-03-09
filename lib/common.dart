import 'dart:math';

import 'package:flutter/material.dart';

double toPrecision(int fractionDigits, double num) {
  var mod = pow(10, fractionDigits.toDouble()).toDouble();
  return ((num * mod).round().toDouble() / mod);
}

enum Encontrado { noEncontrado, correcto, incorrecto }
enum TipoDatos { pdf, xlsx }


const customPadding = EdgeInsets.all(8);

void customSnack(String texto, BuildContext context) {
  SnackBar snackBar = SnackBar(content: Text(texto));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void customDialog(String title, String texto, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Row(
            children: [const Icon(Icons.warning_amber_rounded), Text(texto)],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('Continuar'),
            ),
          ],
        );
      });
}
