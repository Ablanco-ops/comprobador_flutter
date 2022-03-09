

import 'package:comprobador_flutter/presentacion/configuracion_modelos.dart';
import 'package:comprobador_flutter/providers/datos_provider.dart';
import 'package:comprobador_flutter/presentacion/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => Datos()),
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
       
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
      routes: {
        ConfiguracionModelos.routeName: (ctx)=>  const ConfiguracionModelos(),
      },
    );
  }
}

