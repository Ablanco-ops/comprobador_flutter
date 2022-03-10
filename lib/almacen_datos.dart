import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/modelo/archivo_datos.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';

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

List<ArchivoDatos> listaArchivosDatos = [
  ArchivoDatos(nombre: 'CHEP Factura', formato: TipoDatos.xlsx, listaModelos: [
    ModeloDatos(
        nombre: 'CHEP Datos',
        primeraFila: 19,
        idColumna: 'R',
        codProductoColumna: 'B',
        cantidadColumna: 'M',
        sheet: 'Priced GTL v2.0',
        comprobante: {'A18': 'UMI', 'B18': 'Código Producto'},
        fecha: 'T'),
  ], listaHojas: {
    'Priced GTL v2.0'
  }),
  ArchivoDatos(
    nombre: 'Chep Envases',
    formato: TipoDatos.xlsx,
    listaModelos: [
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
    ],
    listaHojas: {
      'SALIDAS PALETS CHEP',
      'SALIDA CHEP - PALETINA',
      'SALIDA CHEP AMERICANO'
    },
  ),
  ArchivoDatos(
      nombre: 'Intrastat Navision',
      formato: TipoDatos.xlsx,
      listaModelos: [
        ModeloDatos(
            nombre: 'Diarios Intrastat',
            primeraFila: 4,
            idColumna: 'C',
            cantidadColumna: 'Q',
            sheet: 'Sheet1',
            fecha: 'B',
            comprobante: {'A3': 'Tipo', 'B3': 'Fecha'})
      ],
      listaHojas: {
        'Sheet1'
      }),
  ArchivoDatos(nombre: 'Intrastat IVA', formato: TipoDatos.xlsx, listaModelos: [
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
  ], listaHojas: {
    'Excel Clientes',
    'Excel Proveedores'
  })
];
