import 'package:comprobador_flutter/datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'datos_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final display = MediaQuery.of(context).size;
    final datos = Provider.of<Datos>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Comparador de archivos')),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const DatosWidget(
              numWidget: 1,
            ),
            const DatosWidget(
              numWidget: 2,
            ),
            Column(
              children: [ElevatedButton(onPressed: datos.cruzarDatos, child: const Text('Cruzar datos'))],
            )
          ],
        ),
      ),
    );
  }
}
