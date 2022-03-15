import 'package:comprobador_flutter/almacen_datos.dart';
import 'package:flutter/material.dart';

class ConfiguracionModelos extends StatelessWidget {
  const ConfiguracionModelos({Key? key}) : super(key: key);
  static const routeName = '/ConfiguracionModelos';

  @override
  Widget build(BuildContext context) {
    var display = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Modelos de datos'),
      ),
      body: Center(
        child: SizedBox(
          width: display.width*0.3,
          child: Column(
            children: [
              ListView.builder(
                  itemCount: listaModelos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(margin: const EdgeInsets.only(bottom: 5),
                      child: ListTile(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        tileColor: Colors.teal,
                        textColor: Colors.white,
                        title: Text(listaModelos[index].nombre),
                        trailing: Container(
                          width: display.width*0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [IconButton(
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
                  Row()
            ],
          ),
        ),
      ),
    );
  }
}
