class Filme {
  int? id;               
  String imagemUrl;      
  String titulo;         
  String genero;         
  String faixaEtaria;    
  int duracao;           
  double pontuacao;      
  String descricao;      
  int ano;               

   Filme({
    this.id,
    required this.imagemUrl,
    required this.titulo,
    required this.genero,
    required this.faixaEtaria,
    required this.duracao,
    required double pontuacao,
    required this.descricao,
    required this.ano,
  })  : assert(pontuacao >= 0 && pontuacao <= 5, 'Pontuação deve estar entre 0 e 5'),
        pontuacao = pontuacao.clamp(0.0, 5.0);

  Map<String, dynamic> toMap() {
    return {
      'id': id,                     
      'imagemUrl': imagemUrl,
      'titulo': titulo,
      'genero': genero,
      'faixaEtaria': faixaEtaria,
      'duracao': duracao,
      'pontuacao': pontuacao,
      'descricao': descricao,
      'ano': ano,
    };
  }

  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'] as int?,
      imagemUrl: map['imagemUrl'] as String,
      titulo: map['titulo'] as String,
      genero: map['genero'] as String,
      faixaEtaria: map['faixaEtaria'] as String,
      duracao: (map['duracao'] as num).toInt(),
      pontuacao: (map['pontuacao'] as num).toDouble(),
      descricao: map['descricao'] as String,
      ano: (map['ano'] as num).toInt(),
    );
  }

}
