import 'dart:convert';
import 'dart:io';

import 'package:comprobador_flutter/datos/almacen_datos.dart';
import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/excepciones.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:flutter/cupertino.dart';

class ModeloProvider extends ChangeNotifier {
  ModeloDatos? modeloDatos;
  bool cambios = false;
  bool iniciado = false;
  List<ModeloDatos> listaModelosDatos = [];

  void refrescarListas(BuildContext context) {
    listaModelosDatos.clear();
    AlmacenDatos.refrescarListas(context);
    listaModelosDatos.addAll(AlmacenDatos.listaModelos);
  }

  void setModelo(ModeloDatos modelo) {
    modeloDatos = modelo;
    notifyListeners();
  }

  void _edtiModelo(CamposModelo campo, String valor) {
    switch (campo) {
      case CamposModelo.cantidadColumna:
        modeloDatos!.cantidadColumna = valor;
        break;
      case CamposModelo.codProducto:
        modeloDatos!.codProducto = valor;
        break;
      case CamposModelo.codProductoColumna:
        modeloDatos!.codProductoColumna = valor;
        break;
      case CamposModelo.comprobante:
        var comprobante = valor.split(':');
        modeloDatos!.comprobante = {comprobante[0]: comprobante[1]};
        break;
      case CamposModelo.fecha:
        modeloDatos!.fecha = valor;
        break;
      case CamposModelo.idColumna:
        modeloDatos!.idColumna = valor;
        break;
      case CamposModelo.nombre:
        modeloDatos!.nombre = valor;
        break;
      case CamposModelo.primeraFila:
        modeloDatos!.primeraFila = int.parse(valor);
        break;
      case CamposModelo.sheet:
        modeloDatos!.sheet = valor;
        break;
      default:
    }
    notifyListeners();
  }

  bool validarTexto(CamposModelo campo, String valor) {
    RegExp pattern;
    switch (campo) {
      case CamposModelo.codProducto:
        pattern = RegExp(r'\S*');
        break;
      case CamposModelo.comprobante:
        pattern = RegExp(r'^\w{2}:.+');
        break;
      case CamposModelo.nombre:
        pattern = RegExp(r'\w+');
        break;
      case CamposModelo.sheet:
        pattern = RegExp(r'.+');
        break;
      case CamposModelo.primeraFila:
        pattern = RegExp(r'^\d{1,2}$');
        break;
      default:
        pattern = RegExp(r'^[A-Z]$');
    }
    if (pattern.hasMatch(valor)) {
      _edtiModelo(campo, valor);
      cambios = true;
      return true;
    } else {
      return false;
    }
  }

  void nuevoModelo() {
    listaModelosDatos.add(ModeloDatos(
        nombre: 'Nuevo Modelo',
        primeraFila: 0,
        idColumna: '',
        cantidadColumna: '',
        sheet: '',
        fecha: '',
        comprobante: {}));
    modeloDatos = listaModelosDatos.firstWhere(
      (element) => element.nombre == 'Nuevo Modelo',
    );
    cambios = true;
    notifyListeners();
  }

  void eliminarModelo(ModeloDatos modelo, BuildContext context) async {
    bool result = await customDialog('Confirme la acción',
        '¿Está seguro de que desea eliminar el modelo?', context);
    if (result) {
      listaModelosDatos.remove(modelo);
      modeloDatos = null;
      cambios = true;
      notifyListeners();
    }
  }

  Future<void> guardarModelos(BuildContext context) async {
    final File file = File(getRoot() + 'modelos.json');
    try {
      await file.writeAsString(json.encode(listaModelosDatos));
      cambios = false;
    } catch (e) {
      mostrarError(TipoError.escrituraModelos, context);
    }
    customSnack('Configuración de modelos guardada en $file', context);
  }
}
