import 'dart:convert';
import 'dart:io';

import 'package:comprobador_flutter/almacen_datos.dart';
import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/modelo/archivo_datos.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:flutter/cupertino.dart';

import '../excepciones.dart';

class ArchivoProvider extends ChangeNotifier {
  ArchivoDatos? archivo;
  bool cambios = false;
  List<ModeloDatos> listaModelosFiltrada = [];
  List<ArchivoDatos> listaArchivosDatos = [];

  void getListaArchivos() {
    listaArchivosDatos.clear();
    listaArchivosDatos.addAll(listaArchivos);
  }

  void setArchivo(ArchivoDatos archivoDatos) {
    archivo = archivoDatos;
    _listarModelos();
    notifyListeners();
  }

  void _listarModelos() {
    listaModelosFiltrada.clear();
    listaModelosFiltrada.addAll(listaModelos);
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
