import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/track.dart'; // Importe o modelo Track

class DatabaseHelper {
  static const _databaseName = "Lapp.db";
  static const _databaseVersion = 1;

  static const tableTracks = 'tracks';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableTracks (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            finishLineStartLat REAL NOT NULL,
            finishLineStartLng REAL NOT NULL,
            finishLineEndLat REAL NOT NULL,
            finishLineEndLng REAL NOT NULL
          )
          ''');
    // A tabela de Laps pode ser criada aqui também, se desejar.
  }

  // --- MÉTODOS CRUD PARA PISTAS ---

  /// Insere uma pista no banco de dados.
  Future<int> insertTrack(Track track) async {
    Database db = await instance.database;
    // O `insert` retorna o ID da linha inserida, mas como usamos um ID de texto,
    // o valor pode não ser útil. `conflictAlgorithm.replace` garante que,
    // se uma pista com o mesmo ID for inserida, ela será substituída.
    return await db.insert(tableTracks, track.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Busca todas as pistas do banco de dados.
  Future<List<Track>> getAllTracks() async {
    Database db = await instance.database;
    // `query` busca todas as linhas da tabela.
    final List<Map<String, dynamic>> maps = await db.query(tableTracks);

    // Converte a List<Map<String, dynamic>> em uma List<Track>.
    return List.generate(maps.length, (i) {
      return Track.fromMap(maps[i]);
    });
  }

  // Aqui podem entrar os métodos para deletar ou atualizar uma pista no futuro.
}
