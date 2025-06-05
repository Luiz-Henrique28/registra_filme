import 'db_helper.dart';
import '../models/filme.dart';

class FilmeRepository {
  final DbHelper _dbHelper = DbHelper();

  Future<int> inserirFilme(Filme filme) async {
    final db = await _dbHelper.database;
    return await db.insert('filmes', filme.toMap());
  }

  Future<List<Filme>> listarFilmes() async {
    final db = await _dbHelper.database;
    final maps = await db.query('filmes');
    return maps.map((m) => Filme.fromMap(m)).toList();
  }

  Future<int> atualizarFilme(Filme filme) async {
    final db = await _dbHelper.database;
    return await db.update(
      'filmes',
      filme.toMap(),
      where: 'id = ?',
      whereArgs: [filme.id],
    );
  }

  Future<int> deletarFilme(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('filmes', where: 'id = ?', whereArgs: [id]);
  }

  Future<Filme?> buscarFilmePorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query('filmes', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Filme.fromMap(maps.first);
    }
    return null;
  }
}
