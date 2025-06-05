// lib/screens/detalhes_filme_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/filme.dart';
import '../data/filme_repository.dart';

class DetalhesFilmeScreen extends StatelessWidget {
  const DetalhesFilmeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final filme = ModalRoute.of(context)!.settings.arguments as Filme;

    return Scaffold(
      appBar: AppBar(
        title: Text(filme.titulo),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/edicao',
                arguments: filme,
              );

              if (result == true) {
                Navigator.of(context).pop(true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: Image.network(
                filme.imagemUrl,
                fit: BoxFit.cover,
                errorBuilder:
                    (_, __, ___) => const Icon(Icons.broken_image, size: 100),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              filme.titulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              '${filme.genero} • ${filme.ano} • ${filme.faixaEtaria}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 12),

            RatingBarIndicator(
              rating: filme.pontuacao,
              itemBuilder:
                  (context, _) => const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 24.0,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Icon(Icons.timer, size: 20),
                const SizedBox(width: 4),
                Text('${filme.duracao} minutos'),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              'Descrição',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(filme.descricao, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
