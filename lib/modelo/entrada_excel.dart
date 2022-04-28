class EntradaExcel {
  final String identificador;
  final String? codProducto;
  final DateTime? fecha;
  final double cantidad1;
  final double cantidad2;

  EntradaExcel({
    required this.identificador,
    this.codProducto,
    this.fecha,
    required this.cantidad1,
    required this.cantidad2,
  });
}
