import 'package:comprobador_flutter/configuracion_modelos.dart';
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                'Configuracion',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              decoration:
                  BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
            ),
            ListTile(
              title: const Text('Archivos de datos'),
              trailing: IconButton(
                icon: const Icon(Icons.architecture_outlined),
                onPressed: () => Navigator.of(context)
                    .pushNamed(ConfiguracionModelos.routeName),
              ),
            ),
            ListTile(
                title: const Text('Modelo de datos'),
                trailing: IconButton(
                  icon: const Icon(Icons.architecture_outlined),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(ConfiguracionModelos.routeName),
                )),
          ],
        ),
      ),
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
            SizedBox(
              height: display.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: datos.cruzarDatos,
                      child: const Text('Cruzar datos')),
                  SizedBox(
                    height: display.height * 0.1,
                  ),
                  ElevatedButton(
                      onPressed: datos.exportar,
                      child: const Text('Exportar excel'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
