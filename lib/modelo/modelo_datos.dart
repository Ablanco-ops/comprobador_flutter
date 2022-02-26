class ModeloDatos {
  String nombre;
  int primeraFila;
  String idColumna;
  String cantidadColumna;
  String sheet;
  String fecha;
  Map<String, String> comprobante;
  ModeloDatos({
    required this.nombre,
    required this.primeraFila,
    required this.idColumna,
    required this.cantidadColumna,
    required this.sheet,
    required this.fecha,
    required this.comprobante,
  });

  @override
  String toString() {
    return 'ModeloDatos(nombre: $nombre, primeraFila: $primeraFila, idColumna: $idColumna, cantidadColumna: $cantidadColumna, sheet: $sheet, fecha: $fecha, comprobante: $comprobante)';
  }
}
