import 'package:comprobador_flutter/common.dart';

// Clase que describe cada entrada de datos
class EntradaDatos {
  final String identificador;
  final String? codProducto;
  double cantidad;
  final String modelo;
  final String fecha;
  Filtro encontrado = Filtro.noEncontrado;
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
