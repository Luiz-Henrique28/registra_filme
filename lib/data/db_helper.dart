import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  Database? _database;

  factory DbHelper() => _instance;
  DbHelper._internal();

  
  Future<Database> get database async {
    if (_database != null) return _database!;
    
    final docsDir = await getApplicationDocumentsDirectory();
    
    final path = join(docsDir.path, 'filmes.db');

    
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        
        await db.execute('''
          CREATE TABLE filmes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            imagemUrl TEXT,
            titulo TEXT,
            genero TEXT,
            faixaEtaria TEXT,
            duracao INTEGER,
            pontuacao REAL,
            descricao TEXT,
            ano INTEGER
          )
        ''');
      },
    );
    return _database!;
  }
}
