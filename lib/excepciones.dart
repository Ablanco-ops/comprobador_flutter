import 'package:flutter/material.dart';

enum TipoExcepcion { archivoIncorrecto, datosIncorrectos, noEncontrado }
enum TipoError {
  lectura,
  extraerPdf,
  extraerXlsx,
  escrituraExcel,
}

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

void mostrarExcepcion(TipoExcepcion tipoExcepcion, BuildContext context) {
  switch (tipoExcepcion) {
    case TipoExcepcion.archivoIncorrecto:
      {
        _customAlert('Archivo Incorrecto',
            'El archivo seleccionado no es válido', context);
      }
      break;
    default:
  }
}

void mostrarError(TipoError tipoError, BuildContext context) {
  switch (tipoError) {
    case TipoError.lectura:
      _customAlert('Error de lectura', 'Error al leer excel', context);
      break;
    case TipoError.escrituraExcel:
      _customAlert('Error de escritura',
          'Error al guardar el exportar archivo Exccel', context);
      break;
    default:
  }
}
