import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:comprobador_flutter/almacen_datos.dart';
import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/providers/modelo_provider.dart';

import 'modelo_edit_tile.dart';

class ConfiguracionModelosScreen extends StatelessWidget {
  const ConfiguracionModelosScreen({Key? key}) : super(key: key);
  static const routeName = '/ConfiguracionModelos';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ModeloProvider>(context);
    var display = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () async {
          if (provider.cambios) {
            bool result = await customDialog(
                'Confirmar', '¿Desea guardar los cambios?', context);
            if (result) {
              provider.guardarModelos(context);
            }
          }

          Navigator.pop(context);
        }),
        title: const Text('Configuración de Modelos de datos'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: display.height * 0.1),
        // width: display.width*0.7,
        height: display.height * 0.8,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: display.width * 0.3,
                child: Row(
                  children: [
                    Expanded(
                      // height: display.height * 0.6,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListView.builder(
                            itemCount: listaModelos.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: ListTile(
                                  onTap: (() =>
                                      provider.setModelo(listaModelos[index])),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  tileColor: Colors.green,
                                  textColor: Colors.white,
                                  title: Text(listaModelos[index].nombre),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => provider.eliminarModelo(
                                        listaModelos[index], context),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: provider.nuevoModelo,
                            icon: const Icon(
                              Icons.add_circle,
                              size: 36,
                            ),
                            color: Colors.green),
                        const SizedBox(height: 10),
                        IconButton(
                            onPressed: () => provider.guardarModelos(context),
                            icon: const Icon(
                              Icons.save,
                              size: 36,
                            ),
                            color: Colors.red),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: display.width * 0.4,
                height: display.height * 0.8,
                child: Column(
                  children: [
                    Card(
                      child: SizedBox(
                        // width: display.width * 0.3,
                        // height: display.height * 0.5,
                        child: Column(
                          children: const [
                            ModeloEditTile(
                                titulo: 'Nombre', campo: CamposModelo.nombre),
                            ModeloEditTile(
                                titulo: 'Primera Fila',
                                campo: CamposModelo.primeraFila),
                            ModeloEditTile(
                                titulo: 'Columna Id',
                                campo: CamposModelo.idColumna),
                            ModeloEditTile(
                                titulo: 'Columna Cod Producto',
                                campo: CamposModelo.codProductoColumna),
                            ModeloEditTile(
                                titulo: 'Columna Fecha',
                                campo: CamposModelo.fecha),
                            ModeloEditTile(
                                titulo: 'Cod Producto',
                                campo: CamposModelo.codProducto),
                            ModeloEditTile(
                                titulo: 'Hoja Excel',
                                campo: CamposModelo.sheet),
                            ModeloEditTile(
                                titulo: 'Comprobante',
                                campo: CamposModelo.comprobante),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
