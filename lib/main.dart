import 'package:comprobador_flutter/presentacion/configuracion_archivos_screen.dart';
import 'package:comprobador_flutter/presentacion/configuracion_modelos_screen.dart';
import 'package:comprobador_flutter/providers/archivo_provider.dart';
import 'package:comprobador_flutter/providers/datos_provider.dart';
import 'package:comprobador_flutter/presentacion/home_screen.dart';
import 'package:comprobador_flutter/providers/modelo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => DatosProvider()),
      ChangeNotifierProvider(create: (ctx) => ModeloProvider()),
      ChangeNotifierProvider(create: (ctx) => ArchivoProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comprobador datos excel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        listTileTheme: ListTileThemeData(
            tileColor: Colors.green,
            textColor: Colors.white,
            iconColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
      routes: {
        ConfiguracionModelosScreen.routeName: (ctx) =>
            const ConfiguracionModelosScreen(),
        ConfiguracionArchivosScreen.routeName: (ctx) =>
            const ConfiguracionArchivosScreen(),
      },
    );
  }
}
