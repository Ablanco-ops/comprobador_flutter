import 'package:comprobador_flutter/almacen_datos.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:comprobador_flutter/providers/archivo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfiguracionArchivosScreen extends StatefulWidget {
  const ConfiguracionArchivosScreen({Key? key}) : super(key: key);
  static const routeName = '/ConfiguracionArchivos';

  @override
  State<ConfiguracionArchivosScreen> createState() =>
      _ConfiguracionArchivosScreenState();
}

class _ConfiguracionArchivosScreenState
    extends State<ConfiguracionArchivosScreen> {
  final _controller = TextEditingController();
  bool editandoNombre = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArchivoProvider>(context);
    final display = MediaQuery.of(context).size;

    String nombre = '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de archivos de datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(
            width: display.width * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Archivos de Datos',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: ListView(
                              // shrinkWrap: true,
                              children: provider
                                  .getListaArchivos()
                                  .map((e) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ListTile(
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          tileColor: Colors.green,
                                          onTap: () => provider.setArchivo(e),
                                          title: Text(e.nombre),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => provider
                                                .borrarArchivo(e, context),
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: provider.addArchivo,
                              icon: const Icon(
                                Icons.add_circle,
                                size: 36,
                              ),
                              color: Colors.green),
                          const SizedBox(height: 10),
                          IconButton(
                              onPressed: () =>
                                  provider.guardarArchivos(context),
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
              ],
            ),
          ),
          SizedBox(
            width: display.width * 0.3,
            child: Card(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Nombre:'),
                    SizedBox(
                      width: display.width * 0.2,
                      child: editandoNombre
                          ? TextField(
                              controller: _controller,
                              onChanged: (value) => nombre = value,
                            )
                          : Text(provider.archivo?.nombre ?? ''),
                    ),
                    if (provider.archivo != null)
                      IconButton(
                          onPressed: () => setState(() {
                                if (editandoNombre) {
                                  provider.editNombre(nombre, context);
                                  _controller.clear();
                                }
                                editandoNombre = !editandoNombre;
                              }),
                          icon: const Icon(Icons.edit))
                  ],
                ),
                Expanded(
                  child: DragTarget(
                    onWillAccept: (data) => true,
                    onAccept: (ModeloDatos modelo) =>
                        provider.addModelo(modelo, context),
                    builder: (BuildContext context, List<dynamic> candidateData,
                        List<dynamic> rejectedData) {
                      return Card(
                        child: provider.archivo == null
                            ? const Padding(
                                padding: EdgeInsets.all(8),
                                child: Center(
                                    child: Text('Arrastre aquí los modelos')))
                            : ListView(
                                children: (provider.archivo!.listaModelos
                                    .map((e) => ListTile(
                                        title: Text(e),
                                        trailing: IconButton(
                                          onPressed: () =>
                                              provider.borrarModelo(e),
                                          icon: const Icon(Icons.delete),
                                        )))).toList(),
                              ),
                      );
                    },
                  ),
                )
              ]),
            ),
          ),
          SizedBox(
            width: display.width * 0.3,
            child: Card(
                child: ListView.builder(
                    itemCount: provider.listaModelosFiltrada.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Draggable(
                          feedback: const Icon(
                            Icons.folder,
                            size: 36,
                            color: Colors.amber,
                          ),
                          data: provider.listaModelosFiltrada[index],
                          dragAnchorStrategy: pointerDragAnchorStrategy,
                          child: ListTile(
                              title: Text(provider
                                  .listaModelosFiltrada[index].nombre)));
                    })),
          )
        ]),
      ),
    );
  }
}
