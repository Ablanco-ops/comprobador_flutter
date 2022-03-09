import 'package:flutter/material.dart';

class ConfiguracionModelos extends StatelessWidget {
  const ConfiguracionModelos({Key? key}) : super(key: key);
  static const routeName = '/ConfiguracionModelos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Modelos de datos'),),
      body: const Text('Configuración'),
    );
  }
}
