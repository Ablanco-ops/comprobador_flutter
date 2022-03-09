import 'package:flutter/material.dart';

enum TipoExcepcion { datosIncorrectos, noEncontrado }
enum TipoError {
  lectura,
  escritura,
}

class Excepciones {
  void _customAlert(String title, String texto, BuildContext context) {
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

  void excepcion(TipoExcepcion tipoExcepcion, BuildContext context) {
    switch (tipoExcepcion) {
      case TipoExcepcion.datosIncorrectos:
        {
          
        }
        break;
      default:
    }
  }
}
