import 'dart:convert';
import 'dart:io';

import 'package:comprobador_flutter/excepciones.dart';
import 'package:comprobador_flutter/modelo/archivo_datos.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'common.dart';

String pathModelos = '';
bool _iniciado = false;

List<ModeloDatos> listaModelos = [
  ModeloDatos(
      nombre: 'CHEP Datos',
      primeraFila: 19,
      idColumna: 'R',
      codProductoColumna: 'B',
      cantidadColumna: 'M',
      sheet: 'Priced GTL v2.0',
      comprobante: {'A18': 'UMI', 'B18': 'Código Producto'},
      fecha: 'T'),
  ModeloDatos(
      nombre: 'Chep Palets',
      primeraFila: 7,
      idColumna: 'F',
      codProducto: '00003',
      cantidadColumna: 'G',
      sheet: 'SALIDAS PALETS CHEP',
      comprobante: {'A1': 'Producto', 'B1': '91908 - PALET CHEP 800X1200'},
      fecha: 'C'),
  ModeloDatos(
      nombre: 'Chep Paletinas',
      primeraFila: 7,
      idColumna: 'F',
      codProducto: '00008',
      cantidadColumna: 'G',
      sheet: 'SALIDA CHEP - PALETINA',
      comprobante: {'A1': 'Producto', 'B1': '91927 - PALET CHEP 800X600'},
      fecha: 'C'),
  ModeloDatos(
      nombre: 'Chep Americano',
      primeraFila: 2,
      idColumna: 'F',
      codProducto: '00001',
      cantidadColumna: 'G',
      sheet: 'SALIDA CHEP - PALETINA',
      comprobante: {'A1': 'Año', 'B1': 'Mes'},
      fecha: 'C'),
  ModeloDatos(
      nombre: 'Diarios Intrastat',
      primeraFila: 4,
      idColumna: 'C',
      cantidadColumna: 'Q',
      sheet: 'Sheet1',
      fecha: 'B',
      comprobante: {'A3': 'Tipo', 'B3': 'Fecha'}),
  ModeloDatos(
      nombre: 'Excel Clientes',
      primeraFila: 6,
      idColumna: 'E',
      cantidadColumna: 'F',
      sheet: 'Clientes',
      fecha: 'D',
      comprobante: {'B1': 'IVA CLIENTES'}),
  ModeloDatos(
      nombre: 'Excel Proveedores',
      primeraFila: 6,
      idColumna: 'E',
      cantidadColumna: 'F',
      sheet: 'Proveedores',
      fecha: 'D',
      comprobante: {'B1': 'IVA PROVEEDORES'})
];

List<ArchivoDatos> listaArchivos = [
  ArchivoDatos(
      nombre: 'CHEP Factura',
      listaModelos: ['CHEP Datos'],
      listaHojas: {'Priced GTL v2.0'}),
  ArchivoDatos(
    nombre: 'Chep Envases',
    listaModelos: [
      'Chep Palets',
      'Chep Paletinas',
      'Chep Americano',
    ],
    listaHojas: {
      'SALIDAS PALETS CHEP',
      'SALIDA CHEP - PALETINA',
      'SALIDA CHEP AMERICANO'
    },
  ),
  ArchivoDatos(
      nombre: 'Intrastat Navision',
      listaModelos: ['Diarios Intrastat'],
      listaHojas: {'Sheet1'}),
  ArchivoDatos(
      nombre: 'Intrastat IVA',
      listaModelos: ['Excel Clientes', 'Excel Proveedores'],
      listaHojas: {'Clientes', 'Proveedores'})
];

void refrescarListas(BuildContext context) async {
    final File configModelos = File(getRoot() + 'modelos.json');
    final File configArchivos = File(getRoot() + 'archivos.json');
    bool cargados = true;
    if (!_iniciado) {
      try {
        List<dynamic> lista = jsonDecode(await configModelos.readAsString());
        listaModelos = (lista.map((e) => ModeloDatos.fromJson(e))).toList();
        if (kDebugMode) {
          print(getRoot() + 'modelos.json');
        }
      } catch (e) {
        cargados = false;
        mostrarError(TipoError.lecturaModelos, context);
      }
      try {
        List<dynamic> lista = jsonDecode(await configArchivos.readAsString());
        listaArchivos = (lista.map((e) => ArchivoDatos.fromJson(e))).toList();
        if (kDebugMode) {
          print(getRoot() + 'archivos.json');
        }
      } catch (e) {
        cargados = false;
        mostrarError(TipoError.lecturaArchivos, context);
      }
      if (cargados) {
        customSnack('Configuración cargada', context);
      }
      _iniciado = true;
    }
  }
