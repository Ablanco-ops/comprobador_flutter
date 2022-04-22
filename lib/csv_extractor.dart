import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

List<List<dynamic>> leerCsv(File file, BuildContext context) {
  final String raw = file.readAsStringSync();
  final res = const CsvToListConverter(fieldDelimiter: ';').convert(raw);
  if (kDebugMode) {
    print(res);
  }
  return res;
}
