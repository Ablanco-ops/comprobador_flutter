import 'package:json_annotation/json_annotation.dart';
part 'modelo_datos.g.dart';

@JsonSerializable(explicitToJson: true)
class ModeloDatos {
   String nombre;
   int primeraFila;
   String idColumna;
   String? codProductoColumna;
   String? codProducto;
   String cantidadColumna;
   String sheet;
   String fecha;
   Map<String, String> comprobante;
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
