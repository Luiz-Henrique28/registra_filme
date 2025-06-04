// lib/screens/cadastro_filme_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../data/filme_repository.dart';
import '../models/filme.dart';

class CadastroFilmeScreen extends StatefulWidget {
  const CadastroFilmeScreen({super.key});

  @override
  State<CadastroFilmeScreen> createState() => _CadastroFilmeScreenState();
}

class _CadastroFilmeScreenState extends State<CadastroFilmeScreen> {
  // Chave global para referenciar o Form e validar
  final _formKey = GlobalKey<FormState>();

  // Controladores para cada campo de texto
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _duracaoController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _imagemUrlController = TextEditingController();

  // Variáveis para faixa etária e pontuação (rating)
  String? _faixaEtariaSelecionada;
  double _pontuacao = 0.0;

  @override
  void dispose() {
    // Liberar controladores quando a tela for destruída
    _tituloController.dispose();
    _generoController.dispose();
    _duracaoController.dispose();
    _descricaoController.dispose();
    _anoController.dispose();
    _imagemUrlController.dispose();
    super.dispose();
  }

  /// Função que será chamada ao pressionar "Salvar"
  Future<void> _salvarFilme() async {
    if (_formKey.currentState!.validate()) {
      // Cria o objeto Filme a partir dos valores do formulário
      final novoFilme = Filme(
        imagemUrl: _imagemUrlController.text.trim(),
        titulo: _tituloController.text.trim(),
        genero: _generoController.text.trim(),
        faixaEtaria: _faixaEtariaSelecionada!,
        duracao: int.parse(_duracaoController.text.trim()),
        pontuacao: _pontuacao,
        descricao: _descricaoController.text.trim(),
        ano: int.parse(_anoController.text.trim()),
      );

      // Insere no banco via repositório
      await FilmeRepository().inserirFilme(novoFilme);

      // Volta para a tela anterior retornando 'true' para recarregar lista
      if (!mounted) return;
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Filme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Campo: Título
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

              // Campo: Gênero
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

              // Campo: Faixa Etária (Dropdown)
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

              // Campo: Duração (número)
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

              // Campo: Pontuação (RatingBar interativo)
              const Text('Pontuação'),
              RatingBar.builder(
                initialRating: 0,
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 32.0,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  _pontuacao = rating;
                },
              ),
              const SizedBox(height: 12),

              // Campo: Descrição (multilinha)
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

              // Campo: Ano (número)
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

              // Campo: URL da Imagem
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
                  // Validação básica de URL
                  final uri = Uri.tryParse(value.trim());
                  if (uri == null || !uri.isAbsolute) {
                    return 'URL inválida';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão Salvar
              ElevatedButton(
                onPressed: _salvarFilme,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
