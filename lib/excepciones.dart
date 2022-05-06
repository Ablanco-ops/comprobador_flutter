import 'package:flutter/material.dart';

enum TipoExcepcion { archivoIncorrecto, datosIncorrectos, errorNumerico }
enum TipoError {
  lecturaExcel,
  lecturaModelos,
  lecturaArchivos,
  extraerPdf,
  extraerXlsx,
  escrituraExcel,
  escrituraModelos,
  escrituraArchivos
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

void mostrarExcepcion(TipoExcepcion tipoExcepcion,String valor, BuildContext context) {
  switch (tipoExcepcion) {
    case TipoExcepcion.datosIncorrectos:
      {
        _customAlert('Datos incorrectos',
            'La hoja $valor no cumple la comprobación', context);
      }
      break;
    case TipoExcepcion.archivoIncorrecto:
      {
        _customAlert('Archivo incorrecto',
            'El archivo no se ajusta a ningun tipo registrado', context);
      }
      break;
      case TipoExcepcion.errorNumerico:
      {
        _customAlert('Error de formato',
            'Valores incorrectos en la columna de cantidad: $valor', context);
      }
      break;
    default:
  }
}

void mostrarError(TipoError tipoError, BuildContext context) {
  switch (tipoError) {
    case TipoError.lecturaExcel:
      _customAlert('Error de lectura', 'Error al leer archivo', context);
      break;
    case TipoError.lecturaModelos:
      _customAlert('Error de lectura', 'Error al leer el archivo de configuración de modelos', context);
      break;
      case TipoError.lecturaArchivos:
      _customAlert('Error de lectura', 'Error al leer el archivo de configuración de archivos', context);
      break;
    case TipoError.escrituraExcel:
      _customAlert('Error de escritura',
          'Error al exportar a archivo Exccel', context);
      break;
    case TipoError.escrituraModelos:
      _customAlert('Error de escritura',
          'Error al guardar el archivo de configuración de modelos', context);
      break;
      case TipoError.escrituraArchivos:
      _customAlert('Error de escritura',
          'Error al guardar el archivo de configuración de Archivos', context);
      break;
    default:
  }
}
