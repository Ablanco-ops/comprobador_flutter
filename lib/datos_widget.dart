import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/modelo/archivo_datos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'almacen_datos.dart';
import 'datos_provider.dart';

class DatosWidget extends StatelessWidget {
  const DatosWidget({
    Key? key,
    required this.numWidget,
  }) : super(key: key);

  final int numWidget;

  @override
  Widget build(BuildContext context) {
    final display = MediaQuery.of(context).size;
    final datos = Provider.of<Datos>(context);
    MaterialColor getColor(Encontrado encontrado) {
      if (encontrado == Encontrado.correcto) {
        return Colors.green;
      } else if (encontrado == Encontrado.incorrecto) {
        return Colors.red;
      } else {
        return Colors.grey;
      }
    }

    return Column(children: [
      SingleChildScrollView(
        child: Container(
            width: display.width * 0.3,
            height: display.height * 0.6,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: datos.getListEntradas(numWidget).isEmpty
                ? const Center(child: Text('Elige modelo de datos y archivo'))
                : ListView.builder(
                  clipBehavior: Clip.antiAlias,
                    shrinkWrap: true,
                    itemCount: datos.getListEntradas(numWidget).length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        tileColor: getColor(
                            datos.getListEntradas(numWidget)[index].encontrado),
                        title: Text(datos
                            .getListEntradas(numWidget)[index]
                            .identificador),
                        trailing: Text(datos
                            .getListEntradas(numWidget)[index]
                            .cantidad
                            .toString()),
                        subtitle:
                            Text(datos.getListEntradas(numWidget)[index].fecha),
                      );
                    })),
      ),
      
      Container(
        color: Colors.white,
        height: display.height*0.25,
        width: display.width*0.3,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PopupMenuButton<ArchivoDatos>(
                      child: Text(
                          numWidget == 1 ? datos.nombreArchivo1 : datos.nombreArchivo2),
                      onSelected: (value) => datos.setArchivo(numWidget, value),
                      itemBuilder: (BuildContext context) => listaArchivosDatos
                          .map((archivo) => PopupMenuItem<ArchivoDatos>(
                                value: archivo,
                                child: Text(archivo.nombre),
                              ))
                          .toList()),
                ),
                ElevatedButton(
                    onPressed: () => datos.seleccionarArchivo(numWidget),
                    child: const Text('Seleccionar Archivo'))
              ],
            ),
            Text(datos.getPath(numWidget).path)
          ],
        ),
      )
    ]);
  }
}
