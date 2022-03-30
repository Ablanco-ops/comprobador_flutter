import 'package:comprobador_flutter/datos/almacen_datos.dart';
import 'package:comprobador_flutter/modelo/modelo_datos.dart';
import 'package:comprobador_flutter/providers/archivo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common.dart';

// Pantalla en la que configuramos los archivos de datos, los datos y funciones
// empleados por esta clase estan en providers/archivo_provider.dart

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
  bool _iniciado = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArchivoProvider>(context);
    final display = MediaQuery.of(context).size;
    if (!_iniciado) {
      //Refresca los datos cada vez que accedemos a la pantalla de configuracion
      provider.getListaArchivos(context);
      _iniciado = true;
    }

    String nombre = '';
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () async {
          //en caso de haber cambios nos pregunta antes de salir
          if (provider.cambios) {
            bool result = await customDialog(
                'Confirmar', '¿Desea guardar los cambios?', context);
            if (result) {
              provider.guardarArchivos(context);
            }
          }
          provider.cambios = false;
          _iniciado = false;
          AlmacenDatos.refrescarListas(context);
          Navigator.pop(context);
        }),
        title: const Text('Configuración de archivos de datos'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          //Lista de los arcihvos de datos configurados
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
                              children: provider.listaArchivosDatos
                                  .map((e) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: ListTile(
                                          onTap: () => provider.setArchivo(e),
                                          title: Text(e.nombre),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                            ),
                                            onPressed: () => provider
                                                .borrarArchivo(e, context),
                                          ),
                                        ),
                                      ))
                                  .toList()),
                        ),
                      ),
                      //Botones laterales de la lista de archivos
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
          // Configuración del archivo seleccionado
          SizedBox(
            width: display.width * 0.3,
            child: Column(
              children: [
                Text('Configuración',
                    style: Theme.of(context).textTheme.headline4),
                Expanded(
                  child: Card(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nombre: ',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Expanded(
                            child: editandoNombre
                                ? TextField(
                                    controller: _controller,
                                    onChanged: (value) => nombre = value,
                                  )
                                : Text(provider.archivo?.nombre ?? '',
                                    style:
                                        Theme.of(context).textTheme.headline5),
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
                          //los modelos de datos pueden ser arrastrados aquí para añadirlos al archivo
                          onWillAccept: (data) => true,
                          onAccept: (ModeloDatos modelo) =>
                              provider.addModelo(modelo, context),
                          builder: (BuildContext context,
                              List<dynamic> candidateData,
                              List<dynamic> rejectedData) {
                            return Card(
                              color: Theme.of(context).primaryColorLight,
                              child: provider.archivo == null
                                  ? const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Center(
                                          child: Text(
                                              'Arrastre aquí los modelos')))
                                  : ListView(
                                      children: (provider.archivo!.listaModelos
                                          .map((e) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: ListTile(
                                                    title: Text(e),
                                                    trailing: IconButton(
                                                      onPressed: () => provider
                                                          .borrarModelo(e),
                                                      icon: const Icon(
                                                          Icons.delete),
                                                    )),
                                              ))).toList(),
                                    ),
                            );
                          },
                        ),
                      )
                    ]),
                  ),
                ),
              ],
            ),
          ),

          //lista de modelos que se pueden añadir al archivo
          SizedBox(
            width: display.width * 0.3,
            child: Column(
              children: [
                Text('Modelos', style: Theme.of(context).textTheme.headline4),
                Expanded(
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
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: ListTile(
                                      onTap: () => _customSimpleDialog(
                                          'Información del modelo',
                                          '',
                                          context,
                                          provider.listaModelosFiltrada[index]),
                                      title: Text(provider
                                          .listaModelosFiltrada[index].nombre)),
                                ));
                          })),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

Future<void> _customSimpleDialog(String title, String texto,
    BuildContext context, ModeloDatos modelo) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
            title: Text(title),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('Nombre: ${modelo.nombre}'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('Hoja: ${modelo.sheet}'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('Identificador: ${modelo.idColumna}'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('Fecha: ${modelo.fecha}'),
              ),
              Center(
                  child: SimpleDialogOption(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Ok',
                          style: Theme.of(context).textTheme.headline6))),
            ],
          ));
}
