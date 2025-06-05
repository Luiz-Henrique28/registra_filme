//

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../data/filme_repository.dart';
import '../models/filme.dart';

class EdicaoFilmeScreen extends StatefulWidget {
  const EdicaoFilmeScreen({super.key});

  @override
  State<EdicaoFilmeScreen> createState() => _EdicaoFilmeScreenState();
}

class _EdicaoFilmeScreenState extends State<EdicaoFilmeScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _tituloController;
  late TextEditingController _generoController;
  late TextEditingController _duracaoController;
  late TextEditingController _descricaoController;
  late TextEditingController _anoController;
  late TextEditingController _imagemUrlController;

  String? _faixaEtariaSelecionada;
  double _pontuacao = 0.0;

  late Filme _filmeOriginal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _filmeOriginal = ModalRoute.of(context)!.settings.arguments as Filme;

    _tituloController = TextEditingController(text: _filmeOriginal.titulo);
    _generoController = TextEditingController(text: _filmeOriginal.genero);
    _duracaoController = TextEditingController(
      text: _filmeOriginal.duracao.toString(),
    );
    _descricaoController = TextEditingController(
      text: _filmeOriginal.descricao,
    );
    _anoController = TextEditingController(text: _filmeOriginal.ano.toString());
    _imagemUrlController = TextEditingController(
      text: _filmeOriginal.imagemUrl,
    );

    _faixaEtariaSelecionada = _filmeOriginal.faixaEtaria;
    _pontuacao = _filmeOriginal.pontuacao;
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _generoController.dispose();
    _duracaoController.dispose();
    _descricaoController.dispose();
    _anoController.dispose();
    _imagemUrlController.dispose();
    super.dispose();
  }

  Future<void> _atualizarFilme() async {
    if (_formKey.currentState!.validate()) {
      final filmeAlterado = Filme(
        id: _filmeOriginal.id,
        imagemUrl: _imagemUrlController.text.trim(),
        titulo: _tituloController.text.trim(),
        genero: _generoController.text.trim(),
        faixaEtaria: _faixaEtariaSelecionada!,
        duracao: int.parse(_duracaoController.text.trim()),
        pontuacao: _pontuacao,
        descricao: _descricaoController.text.trim(),
        ano: int.parse(_anoController.text.trim()),
      );

      await FilmeRepository().atualizarFilme(filmeAlterado);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Filme')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _generoController,
                decoration: const InputDecoration(labelText: 'Gênero'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o gênero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Faixa Etária'),
                value: _faixaEtariaSelecionada,
                items: const [
                  DropdownMenuItem(value: 'Livre', child: Text('Livre')),
                  DropdownMenuItem(value: '10', child: Text('10')),
                  DropdownMenuItem(value: '12', child: Text('12')),
                  DropdownMenuItem(value: '14', child: Text('14')),
                  DropdownMenuItem(value: '16', child: Text('16')),
                  DropdownMenuItem(value: '18', child: Text('18')),
                ],
                onChanged: (value) {
                  setState(() {
                    _faixaEtariaSelecionada = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione a faixa etária';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _duracaoController,
                decoration: const InputDecoration(
                  labelText: 'Duração (minutos)',
                  hintText: 'Ex: 120',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a duração';
                  }
                  final dur = int.tryParse(value.trim());
                  if (dur == null || dur <= 0) {
                    return 'Duração inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              const Text('Pontuação'),
              RatingBar.builder(
                initialRating: _pontuacao,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 32.0,
                itemBuilder:
                    (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  _pontuacao = rating;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _anoController,
                decoration: const InputDecoration(
                  labelText: 'Ano',
                  hintText: 'Ex: 2023',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o ano';
                  }
                  final ano = int.tryParse(value.trim());
                  if (ano == null || ano <= 0) {
                    return 'Ano inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _imagemUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem',
                  hintText: 'https://exemplo.com/capa.jpg',
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a URL da imagem';
                  }
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null || !uri.isAbsolute) {
                    return 'URL inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _atualizarFilme,
                child: const Text('Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
