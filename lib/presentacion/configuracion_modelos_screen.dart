import 'package:comprobador_flutter/almacen_datos.dart';
import 'package:comprobador_flutter/common.dart';
import 'package:comprobador_flutter/providers/modelo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                width: display.width * 0.3,
                height: display.height * 0.8,
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
                          trailing: Container(
                            width: display.width * 0.1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              SizedBox(
                width: display.width * 0.3,
                height: display.height * 0.8,
                child: Column(
                  children: [
                    Card(
                      child: SizedBox(
                        width: display.width * 0.3,
                        height: display.height * 0.5,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Nombre'),
                              trailing:
                                  Text(provider.modeloDatos?.nombre ?? ''),
                              leading: IconButton(icon: Icon(Icons.edit)),
                              onTap: ()=>provider.edtiModelo(CamposModelo.nombre, valor),
                            ),
                            ListTile(title: Text('Primera fila')),
                            ListTile(title: Text('Columna identificador')),
                            ListTile(title: Text('Columna código de producto')),
                            ListTile(title: Text('Código de producto')),
                            ListTile(title: Text('Columna cantidad')),
                            ListTile(title: Text('Nombre de la hoja')),
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
