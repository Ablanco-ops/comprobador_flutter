import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/modelo/entrada_datos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/datos_provider.dart';

/* Widget auxiliar utilizado por home_screen.dart en el que se cargan los 
ficheros a comparar */
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
      //Asigna un color a la entrada de datos en función de si ha encontrado correspondencia o no
      if (encontrado == Filtro.correcto) {
        return Colors.green;
      } else if (encontrado == Filtro.incorrecto) {
        return Colors.red;
      } else {
        return Colors.grey;
      }
    }

    String getSubtitle(EntradaDatos entrada) {
      String res = entrada.fecha + ' - ';
      if (entrada.ciudad != null) {
        res += entrada.ciudad!;
      }
      return res;
    }

    return SizedBox(
      width: display.width * 0.3,
      child: Column(
        children: [
          SizedBox(
              height: display.height * 0.60,
              child: Card(
                  child: datos.getListEntradas(numWidget).isEmpty
                      ? const Center(
                          child: Text('Elige tipo de archivo y localización'))
                      : ListView.builder(
                          controller: ScrollController(),
                          clipBehavior: Clip.antiAlias,
                          shrinkWrap: true,
                          itemCount: datos.getListEntradas(numWidget).length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: ListTile(
                                tileColor: getColor(datos
                                    .getListEntradas(numWidget)[index]
                                    .encontrado),
                                title: Text(datos.getId(numWidget, index)),
                                trailing: Text(datos
                                    .getListEntradas(numWidget)[index]
                                    .cantidad
                                    .toString()),
                                subtitle: Text(getSubtitle(datos.getListEntradas(numWidget)[index])),
                              ),
                            );
                          }))),
          SizedBox(
            height: display.height * 0.25,
            child: Card(
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(10)),
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
            ),
          )
        ],
      ),
    );
  }
}
