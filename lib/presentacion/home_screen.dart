import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/presentacion/configuracion_modelos_screen.dart';
import 'package:comprobador_flutter/providers/datos_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'datos_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final display = MediaQuery.of(context).size;
    final datos = Provider.of<DatosProvider>(context);
    String textoBusqueda = '';
    
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
              leading: IconButton(
                icon: const Icon(Icons.architecture_outlined),
                onPressed: () => Navigator.of(context)
                    .pushNamed(ConfiguracionModelosScreen.routeName),
              ),
            ),
            ListTile(
                title: const Text('Modelo de datos'),
                leading: IconButton(
                  icon: const Icon(Icons.architecture_outlined),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(ConfiguracionModelosScreen.routeName),
                )),
            ListTile(
              title: const Text('Carpeta de destino del archivo excel'),
              subtitle: Text(datos.pathExcelExport),
              leading: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: datos.seleccionarPathExcel,
              ),
            )
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
              height: display.height * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () => datos.cruzarDatos(context),
                      child: const Text('Cruzar datos')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filtro: '),
                      const SizedBox(width: 5),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          // width: display.width * 0.10,
                          padding: customPadding,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: PopupMenuButton<Filtro>(
                                child:
                                    Text(datos.filtroName(datos.filtroDatos),style: const TextStyle(color: Colors.white)),
                                onSelected: (value) =>
                                    datos.filtrarDatos(value),
                                itemBuilder: (BuildContext context) => Filtro
                                    .values
                                    .map((e) => PopupMenuItem<Filtro>(
                                        value: e,
                                        child: Text(datos.filtroName(e))))
                                    .toList()),
                          ),
                        ),
                      ),
                      // Container(
                      //   width: display.width*0.3,
                      //   child: Row(
                      //     children: [TextField(onChanged: ((value) => textoBusqueda = value)),
                      //       IconButton(onPressed: ()=>datos.buscarEntradas(textoBusqueda),  icon: Icon(Icons.search)),
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.greenAccent)),
                    height: display.height * 0.3,
                    width: display.width * 0.2,
                    child: Column(children: [
                      // ListTile(
                      //   title: const Text('Entradas'),
                      //   trailing: Text(
                      //       '${datos.getListEntradas(1).length} - ${datos.getListEntradas(2).length}'),
                      // ),
                      ListTile(
                        title: const Text('No Encontrados'),
                        trailing: Text(datos.noEncontrados.toString()),
                      ),
                      ListTile(
                        title: const Text('Correctos'),
                        trailing: Text(datos.correctos.toString()),
                      ),
                      ListTile(
                        title: const Text('incorrectos'),
                        trailing: Text(datos.incorrectos.toString()),
                      ),
                    ]),
                  ),
                  SizedBox(
                    height: display.height * 0.1,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      onPressed: () => datos.exportar(context),
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
