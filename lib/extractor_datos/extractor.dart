import 'package:comprobador_flutter/modelo/entrada_datos.dart';
import 'package:flutter/cupertino.dart';

abstract class Extractor {
  

  List<EntradaDatos> procesarArchivo(BuildContext context);
  bool getArchivoDatos(BuildContext context);
  List<EntradaDatos> leerArchivo(BuildContext context);
  
}
