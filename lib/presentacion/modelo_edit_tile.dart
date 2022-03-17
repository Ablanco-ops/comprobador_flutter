import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common.dart';
import '../providers/modelo_provider.dart';

class ModeloEditTile extends StatefulWidget {
  final CamposModelo campo;
  final String titulo;

  const ModeloEditTile({
    Key? key,
    required this.campo,
    required this.titulo,
  }) : super(key: key);

  @override
  State<ModeloEditTile> createState() => _EditTileState();
}

class _EditTileState extends State<ModeloEditTile> {
  bool editando = false;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var display = MediaQuery.of(context).size;
    final provider = Provider.of<ModeloProvider>(context);
    String titulo() {
      switch (widget.campo) {
        case (CamposModelo.cantidadColumna):
          return provider.modeloDatos?.cantidadColumna ?? '';
        case (CamposModelo.codProducto):
          return provider.modeloDatos?.codProducto ?? '';
        case (CamposModelo.codProductoColumna):
          return provider.modeloDatos?.codProductoColumna ?? '';
        case (CamposModelo.comprobante):
          return provider.modeloDatos?.comprobante.toString() ?? '';
        case (CamposModelo.fecha):
          return provider.modeloDatos?.fecha ?? '';
        case (CamposModelo.idColumna):
          return provider.modeloDatos?.idColumna ?? '';
        case (CamposModelo.nombre):
          return provider.modeloDatos?.nombre ?? '';
        case (CamposModelo.primeraFila):
          return provider.modeloDatos?.primeraFila.toString() ?? '';
        case (CamposModelo.sheet):
          return provider.modeloDatos?.sheet ?? '';
        default:
          return '';
      }
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.lightGreen),
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
            width: display.width * 0.12,
            padding: const EdgeInsets.only(left: 5),
            child: Text(widget.titulo)),
        SizedBox(
          width: display.width * 0.2,
          child: editando
              ? TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    provider.validarTexto(widget.campo, value);
                  },
                )
              : Text(titulo()),
        ),
        SizedBox(
          width: display.width * 0.05,
          child: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  if (editando) {
                    bool result =
                        provider.validarTexto(widget.campo, _controller.text);
                    if (!result) {
                      customSnack('Entrada no válida', context);
                    }
                    _controller.clear();
                  }
                  editando = !editando;
                });
              }),
        ),
      ]),
    );
    // return ListTile(
    //   title: editando
    //       ? TextField(
    //           controller: _controller,
    //           onSubmitted: (value) {
    //             provider.validarTexto(widget.campo, value);
    //           },
    //         )
    //       : Center(child: Text(titulo())),
    //   trailing: IconButton(
    //       icon: const Icon(Icons.edit),
    //       onPressed: () {
    //         setState(() {
    //           if (editando) {
    //             provider.validarTexto(widget.campo, _controller.text);
    //             _controller.clear();
    //           }
    //           editando = !editando;
    //         });
    //       }),
    //   leading: Text(widget.titulo),
    // );
  }
}
