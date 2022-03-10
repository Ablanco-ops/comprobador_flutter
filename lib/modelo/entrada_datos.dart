import 'package:comprobador_flutter/common.dart';

class EntradaDatos {
  final String identificador;
  final String? codProducto;
  double cantidad;
  final String modelo;
  final String fecha;
  Encontrado encontrado = Encontrado.noEncontrado;
  EntradaDatos({
    required this.identificador,
     this.codProducto,
    required this.cantidad,
    required this.modelo,
    required this.fecha,
  });

  @override
  String toString() =>
      'EntradaDatos(identificador: $identificador, cantidad: $cantidad, modelo: $modelo)';
}
