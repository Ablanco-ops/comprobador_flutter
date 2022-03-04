import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';

class ArchivoDatos {
  final String nombre;
  final TipoDatos formato;
  final List<ModeloDatos> listaModelos;
  ArchivoDatos({
    required this.nombre,
    required this.formato,
    required this.listaModelos,
  });
}
