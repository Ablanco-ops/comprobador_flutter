class EntradaExcel {
  final String identificador1;
  String identificador2;
  final DateTime? fecha;
  final String? ciudad;
  Map<String,double> cantidad1;
  Map<String,double> cantidad2;

  EntradaExcel({
    required this.identificador1,
    required this.identificador2,
    this.fecha,
    this.ciudad,
    required this.cantidad1,
    required this.cantidad2
  });
}
