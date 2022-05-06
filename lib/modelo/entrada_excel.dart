import 'cantidad.dart';

class EntradaExcel {
  String? identificador1;
  String? identificador2;
  final String? fecha;
  final String? ciudad;
  List<Cantidad>? cantidad1;
  List<Cantidad>? cantidad2;

  EntradaExcel({
    this.identificador1,
    this.identificador2,
    required this.fecha,
    required this.ciudad,
    this.cantidad1,
    this.cantidad2
  });
}
