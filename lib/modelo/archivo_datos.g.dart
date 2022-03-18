// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archivo_datos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchivoDatos _$ArchivoDatosFromJson(Map<String, dynamic> json) => ArchivoDatos(
      nombre: json['nombre'] as String,
      listaModelos: (json['listaModelos'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      listaHojas:
          (json['listaHojas'] as List<dynamic>).map((e) => e as String).toSet(),
    );

Map<String, dynamic> _$ArchivoDatosToJson(ArchivoDatos instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'listaModelos': instance.listaModelos,
      'listaHojas': instance.listaHojas.toList(),
    };
