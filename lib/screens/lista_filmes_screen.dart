import 'package:flutter/material.dart';

class ListaFilmesScreen extends StatelessWidget {
  const ListaFilmesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Filmes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => const AlertDialog(
                  content: Text('Nome do Grupo: Luiz Henrique, Kauã Douglas e Pedro Henrique'),
                ),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Tela de listagem ainda não implementada'),
      ),
    );
  }
}
