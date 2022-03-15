import 'package:json_annotation/json_annotation.dart';
part 'modelo_datos.g.dart';

@JsonSerializable()
class ModeloDatos {
  final String nombre;
  final int primeraFila;
  final String idColumna;
  final String? codProductoColumna;
  final String? codProducto;
  final String cantidadColumna;
  final String sheet;
  final String fecha;
  final Map<String, String> comprobante;
  ModeloDatos({
    required this.nombre,
    required this.primeraFila,
    required this.idColumna,
    this.codProductoColumna,
    this.codProducto,
    required this.cantidadColumna,
    required this.sheet,
    required this.fecha,
    required this.comprobante,
  });

  @override
  String toString() {
    return 'ModeloDatos(nombre: $nombre, primeraFila: $primeraFila, idColumna: $idColumna, cantidadColumna: $cantidadColumna, sheet: $sheet, fecha: $fecha, comprobante: $comprobante)';
  }

  factory ModeloDatos.fromJson(Map<String, dynamic> json) =>
      _$ModeloDatosFromJson(json);
  Map<String, dynamic> toJson() => _$ModeloDatosToJson(this);
}
