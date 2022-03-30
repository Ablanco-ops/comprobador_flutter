import 'dart:convert';
import 'dart:io';

import 'package:comprobador_flutter/datos/almacen_datos.dart';
import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/modelo/archivo_datos.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:flutter/cupertino.dart';

import '../excepciones.dart';

// Clase para gestionar los datos que muestra la pantalla de configuración de archivos
class ArchivoProvider extends ChangeNotifier {
  ArchivoDatos? archivo;
  bool cambios = false;
  List<ModeloDatos> listaModelosFiltrada =
      []; // lista delos modelos que podemos añadir al archivo
  List<ArchivoDatos> listaArchivosDatos =
      []; //lista que contiene los archivos de datos pra modificar

  void getListaArchivos(BuildContext context) {
    //obtiene los archivos de datos del almacén
    listaArchivosDatos.clear();
    AlmacenDatos.refrescarListas(context);
    listaArchivosDatos.addAll(AlmacenDatos.listaArchivos);
  }

  void setArchivo(ArchivoDatos archivoDatos) {
    //selecciona el archivo de datos a modificar
    archivo = archivoDatos;
    _listarModelos();
    notifyListeners();
  }

  void _listarModelos() {
    //limpia la lista de modelos, añade todos los del almacén y luego los filtra en función de la lista de nombres del archivo
    listaModelosFiltrada.clear();
    listaModelosFiltrada.addAll(AlmacenDatos.listaModelos);
    listaModelosFiltrada.removeWhere(
        (element) => archivo!.listaModelos.contains(element.nombre));
    notifyListeners();
  }

  void editNombre(String nombre, BuildContext context) async {
    bool result = await customDialog('Confirmación',
        '¿Quiere cambiar el nombre del Archivo de datos?', context);
    if (result) {
      archivo!.nombre = nombre;
      cambios = true;
      notifyListeners();
    }
  }

  void addArchivo() {
    //Crea un archovo de datos y lo selecciona para editar
    listaArchivosDatos.add(ArchivoDatos(
        nombre: 'Nuevo Archivo', listaModelos: [], listaHojas: {}));
    setArchivo(listaArchivosDatos
        .firstWhere((element) => element.nombre == 'Nuevo Archivo'));
    cambios = true;
    notifyListeners();
  }

  void borrarArchivo(ArchivoDatos archivoDatos, BuildContext context) async {
    final result = await customDialog(
        'Confirmación', '¿Desea eliminar el archivo?', context);
    if (result) {
      listaArchivosDatos.remove(archivoDatos);
      archivo = null;
      cambios = true;
      notifyListeners();
    }
  }

  Future<void> guardarArchivos(BuildContext context) async {
    final File file = File(getRoot() + 'archivos.json');
    try {
      await file.writeAsString(json.encode(listaArchivosDatos));
      cambios = false;
    } catch (e) {
      mostrarError(TipoError.escrituraModelos, context);
    }
    customSnack('Configuración de modelos guardada en $file', context);
  }

  void addModelo(ModeloDatos modeloDatos, BuildContext context) {
    archivo!.listaModelos.add(modeloDatos.nombre);
    archivo!.listaHojas.add(modeloDatos.sheet);
    listaModelosFiltrada.remove(modeloDatos);
    cambios = true;
    notifyListeners();
  }

  void borrarModelo(String modelo) {
    archivo!.listaModelos.remove(modelo);
    _listarModelos();
    cambios = true;
    notifyListeners();
  }
}
