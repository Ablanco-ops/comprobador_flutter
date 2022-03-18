import 'package:comprobador_flutter/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/datos_provider.dart';

class DatosWidget extends StatelessWidget {
  const DatosWidget({
    Key? key,
    required this.numWidget,
  }) : super(key: key);

  final int numWidget;

  @override
  Widget build(BuildContext context) {
    final display = MediaQuery.of(context).size;
    final datos = Provider.of<DatosProvider>(context);
    MaterialColor getColor(Filtro encontrado) {
      if (encontrado == Filtro.correcto) {
        return Colors.green;
      } else if (encontrado == Filtro.incorrecto) {
        return Colors.red;
      } else {
        return Colors.grey;
      }
    }

    return SizedBox(
      height: display.height,
      width: display.width * 0.3,
      // color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              height: display.height * 0.55,
              width: display.width * 0.3,
              // color: Colors.red,
              child: datos.getListEntradas(numWidget).isEmpty
                  ? const Center(
                      child: Text('Elige tipo de archivo y localización'))
                  : ListView.builder(
                      controller: ScrollController(),
                      clipBehavior: Clip.antiAlias,
                      shrinkWrap: true,
                      itemCount: datos.getListEntradas(numWidget).length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          tileColor: getColor(datos
                              .getListEntradas(numWidget)[index]
                              .encontrado),
                          title: Text(datos.getId(numWidget, index)),
                          trailing: Text(datos
                              .getListEntradas(numWidget)[index]
                              .cantidad
                              .toString()),
                          subtitle: Text(
                              datos.getListEntradas(numWidget)[index].fecha),
                        );
                      })),
          Container(
            height: display.height * 0.25,
            width: display.width * 0.3,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: customPadding,
                      child: Text(numWidget == 1
                          ? datos.tipoArchivo1
                          : datos.tipoArchivo2),
                    ),
                    Padding(
                      padding: customPadding,
                      child: ElevatedButton(
                          onPressed: () {
                            datos.refrescarListas(context);
                            datos.seleccionarArchivo(numWidget, context);
                          },
                          child: const Text('Seleccionar Archivo')),
                    )
                  ],
                ),
                Padding(
                  padding: customPadding,
                  child: Text(datos.getPath(numWidget).path),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
