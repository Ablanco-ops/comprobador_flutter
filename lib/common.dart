import 'dart:math';

  double toPrecision(int fractionDigits, double num) {
    var mod = pow(10, fractionDigits.toDouble()).toDouble();
    return ((num * mod).round().toDouble() / mod);
  }


enum Encontrado{noEncontrado, correcto, incorrecto}
enum TipoDatos{pdf, xlsx}