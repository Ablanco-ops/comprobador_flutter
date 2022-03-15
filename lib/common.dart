import 'package:flutter/material.dart';

double toPrecision(int fractionDigits, double numero) {
  return (double.parse((numero).toStringAsFixed(fractionDigits)));
}

enum Filtro {todo, noEncontrado, correcto, incorrecto }
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
          content: Text(texto),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('Continuar'),
            ),
          ],
        );
      });
}
