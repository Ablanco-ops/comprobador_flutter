import 'package:comprobador_flutter/common.dart';

class EntradaDatos {
  String identificador;
  double cantidad;
  String modelo;
  String fecha;
  Encontrado encontrado = Encontrado.noEncontrado;
  EntradaDatos({
    required this.identificador,
    required this.cantidad,
    required this.modelo,
    required this.fecha,
  });

  @override
  String toString() =>
      'EntradaDatos(identificador: $identificador, cantidad: $cantidad, modelo: $modelo)';
}
