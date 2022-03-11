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
  String toString() {
    return 'EntradaDatos(identificador: $identificador, codProducto: $codProducto, cantidad: $cantidad, modelo: $modelo, fecha: $fecha, encontrado: $encontrado)';
  }
}
