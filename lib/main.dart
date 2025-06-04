

import 'package:flutter/material.dart';
import 'utils/app_routes.dart';
import 'screens/lista_filmes_screen.dart';
import 'screens/cadastro_filme_screen.dart';
import 'screens/detalhes_filme_screen.dart';
import 'screens/edicao_filme_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registra Filmes',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: AppRoutes.listaFilmes,
      routes: {
        AppRoutes.listaFilmes: (context) => const ListaFilmesScreen(),
        AppRoutes.cadastroFilme: (context) => const CadastroFilmeScreen(),
        AppRoutes.detalhesFilme: (context) => const DetalhesFilmeScreen(),
        AppRoutes.edicaoFilme: (context) => const EdicaoFilmeScreen(),
      },
    );
  }
}
