
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../data/filme_repository.dart';
import '../models/filme.dart';
import '../utils/app_routes.dart';

class ListaFilmesScreen extends StatefulWidget {
  const ListaFilmesScreen({super.key});

  @override
  State<ListaFilmesScreen> createState() => _ListaFilmesScreenState();
}

class _ListaFilmesScreenState extends State<ListaFilmesScreen> {
  late Future<List<Filme>> _futureFilmes;

  @override
  void initState() {
    super.initState();
    _futureFilmes = FilmeRepository().listarFilmes();
  }

  void _atualizarLista() {
    setState(() {
      _futureFilmes = FilmeRepository().listarFilmes();
    });
  }

  Widget _buildOpcoesMenu(BuildContext context, Filme filme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Exibir Dados'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              AppRoutes.detalhesFilme,
              arguments: filme,
            ).then((result) {
              if (result == true) {
                _atualizarLista();
              }
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: const Text('Alterar'),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(
              context,
              AppRoutes.edicaoFilme,
              arguments: filme,
            ).then((result) {
              if (result == true) {
                _atualizarLista();
              }
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Filmes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                AppRoutes.cadastroFilme,
              );
              if (result == true) {
                _atualizarLista();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => const AlertDialog(
                  content: Text('Nome do Grupo: Luiz Henrique, Kauã Douglas, Pedro Henrique'),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Filme>>(
        future: _futureFilmes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final filmes = snapshot.data!;
          if (filmes.isEmpty) {
            return const Center(child: Text('Nenhum filme cadastrado.'));
          }
          return ListView.builder(
            itemCount: filmes.length,
            itemBuilder: (context, index) {
              final filme = filmes[index];
              return Dismissible(
                key: ValueKey(filme.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  final confirmado = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirmar exclusão'),
                      content: Text('Deseja excluir "${filme.titulo}"?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Excluir'),
                        ),
                      ],
                    ),
                  );
                  return confirmado == true;
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) async {
                  await FilmeRepository().deletarFilme(filme.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Filme "${filme.titulo}" excluído')),
                  );
                  _atualizarLista();
                },
                child: ListTile(
                  leading: Image.network(
                    filme.imagemUrl,
                    width: 50,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  ),
                  title: Text(filme.titulo),
                  subtitle: Text(
                      '${filme.genero} • ${filme.ano} • ${filme.faixaEtaria}'),
                  trailing: RatingBarIndicator(
                    rating: filme.pontuacao,
                    itemBuilder: (context, _) =>
                        const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 16.0,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => _buildOpcoesMenu(context, filme),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
