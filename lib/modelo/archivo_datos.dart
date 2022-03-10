import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';

class ArchivoDatos {
  final String nombre;
  final TipoDatos formato;
  final List<ModeloDatos> listaModelos;
  final Set<String> listaHojas;
  ArchivoDatos({
    required this.nombre,
    required this.formato,
    required this.listaModelos,
    required this.listaHojas,
  });
}
