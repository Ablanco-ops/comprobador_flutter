import 'package:json_annotation/json_annotation.dart';

part 'archivo_datos.g.dart';

// Varias hojas de excel con sus respectivos modelos

@JsonSerializable(explicitToJson: true)
class ArchivoDatos {
  String nombre;
  List<String> listaModelos;
  Set<String> listaHojas;
  ArchivoDatos({
    required this.nombre,
    required this.listaModelos,
    required this.listaHojas,
  });

  factory ArchivoDatos.fromJson(Map<String, dynamic> json) =>
      _$ArchivoDatosFromJson(json);

  Map<String, dynamic> toJson() => _$ArchivoDatosToJson(this);
}
