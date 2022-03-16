import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:flutter/cupertino.dart';

class ModeloProvider extends ChangeNotifier {
  ModeloDatos? modeloDatos;

  void setModelo(ModeloDatos modelo) {
    modeloDatos = modelo;
    notifyListeners();
  }

  void edtiModelo(CamposModelo campo, String valor) {
    ModeloDatos nuevoModelo;
    switch (campo) {
      case CamposModelo.cantidadColumna:
        nuevoModelo = ModeloDatos(
            nombre: modeloDatos!.nombre,
            primeraFila: modeloDatos!.primeraFila,
            idColumna: modeloDatos!.idColumna,
            cantidadColumna: valor,
            sheet: modeloDatos!.sheet,
            fecha: modeloDatos!.fecha,
            comprobante: modeloDatos!.comprobante);
        break;
      default:
    }
  }
}
