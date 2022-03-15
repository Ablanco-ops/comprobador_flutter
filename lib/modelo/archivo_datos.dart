import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:json_annotation/json_annotation.dart';
part 'archivo_datos.g.dart';

@JsonSerializable(explicitToJson: true)
class ArchivoDatos {
  final String nombre;
  final List<ModeloDatos> listaModelos;
  final Set<String> listaHojas;
  ArchivoDatos({
    required this.nombre,
    required this.listaModelos,
    required this.listaHojas,
  });

  factory ArchivoDatos.fromJson(Map<String, dynamic> json) =>
      _$ArchivoDatosFromJson(json);

  Map<String, dynamic> toJson() => _$ArchivoDatosToJson(this);
}
