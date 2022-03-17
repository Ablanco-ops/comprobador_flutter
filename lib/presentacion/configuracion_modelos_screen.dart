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
                width: display.width*0.3,
                child: Column(
                  children: [
                    Expanded(
                      // height: display.height * 0.6,
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
                                tileColor: Colors.teal,
                                textColor: Colors.white,
                                title: Text(listaModelos[index].nombre),
                                trailing: SizedBox(
                                  width: display.width * 0.1,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: ()=>provider.eliminarModelo(listaModelos[index]),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    Container(width: display.width*0.3,child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(onPressed: provider.nuevoModelo, icon: const Icon(Icons.add),color: Theme.of(context).primaryColor,),
                        IconButton(onPressed: (){}, icon: const Icon(Icons.save),color: Theme.of(context).primaryColor)
                      ],
                    )),
                    
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
                            ModeloEditTile(titulo: 'Nombre',campo: CamposModelo.nombre),
                            ModeloEditTile(titulo: 'Primera Fila',campo: CamposModelo.primeraFila),
                            ModeloEditTile(titulo: 'Columna Id',campo: CamposModelo.idColumna),
                            ModeloEditTile(titulo: 'Columna Cod Producto',campo: CamposModelo.codProductoColumna),
                            ModeloEditTile(titulo: 'Columna Fecha',campo: CamposModelo.fecha),
                            ModeloEditTile(titulo: 'Cod Producto',campo: CamposModelo.codProducto),
                            ModeloEditTile(titulo: 'Hoja Excel',campo: CamposModelo.sheet),
                            ModeloEditTile(titulo: 'Comprobante',campo: CamposModelo.comprobante),
                            
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



