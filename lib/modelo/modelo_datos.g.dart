// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modelo_datos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModeloDatos _$ModeloDatosFromJson(Map<String, dynamic> json) => ModeloDatos(
      nombre: json['nombre'] as String,
      primeraFila: json['primeraFila'] as int,
      idColumna: json['idColumna'] as String,
      codProductoColumna: json['codProductoColumna'] as String?,
      codProducto: json['codProducto'] as String?,
      cantidadColumna: json['cantidadColumna'] as String,
      sheet: json['sheet'] as String,
      fecha: json['fecha'] as String,
      comprobante: Map<String, String>.from(json['comprobante'] as Map),
    );

Map<String, dynamic> _$ModeloDatosToJson(ModeloDatos instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'primeraFila': instance.primeraFila,
      'idColumna': instance.idColumna,
      'codProductoColumna': instance.codProductoColumna,
      'codProducto': instance.codProducto,
      'cantidadColumna': instance.cantidadColumna,
      'sheet': instance.sheet,
      'fecha': instance.fecha,
      'comprobante': instance.comprobante,
    };
