import 'package:json_annotation/json_annotation.dart';
part 'modelo_datos.g.dart';

// Modelo de datos para buscar las entradas en una hoja de excel
@JsonSerializable(explicitToJson: true)
class ModeloDatos {
  String nombre;
  int primeraFila;
  String idColumna;
  String? ciudad;
  String? codProductoColumna;
  String? codProducto;
  String cantidadColumna;
  String sheet;
  String fecha;
  Map<String, String> comprobante;
  Map<String, String>? dictCiudades;
  Map<String, String>? productos;
  ModeloDatos({
    required this.nombre,
    required this.primeraFila,
    required this.idColumna,
    this.ciudad,
    this.codProductoColumna,
    this.codProducto,
    required this.cantidadColumna,
    required this.sheet,
    required this.fecha,
    required this.comprobante,
    this.dictCiudades,
    this.productos
  });

  @override
  String toString() {
    return 'ModeloDatos(nombre: $nombre, primeraFila: $primeraFila, idColumna: $idColumna, cantidadColumna: $cantidadColumna, sheet: $sheet, fecha: $fecha, comprobante: $comprobante)';
  }

  factory ModeloDatos.fromJson(Map<String, dynamic> json) =>
      _$ModeloDatosFromJson(json);
  Map<String, dynamic> toJson() => _$ModeloDatosToJson(this);
}
