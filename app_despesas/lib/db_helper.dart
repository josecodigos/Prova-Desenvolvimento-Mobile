import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'despesa.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper get instance => _instance;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

Future<Database> _initDatabase() async {
  
  final directory = await getApplicationDocumentsDirectory();
  final path = join(directory.path, 'agendaFinanceira.db');
  print('Database path: $path');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE despesa (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            descricao TEXT,
            valor DOUBLE,
            data TEXT
          )
        ''');
      },
    );
  }
    Future<void> insertDespesa(Despesa despesa) async {
    final db = await database;
    await db.insert('despesa', despesa.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Despesa>>getDespesa() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('despesa');

    return List.generate(maps.length, (i) {
      return Despesa.fromMap(maps[i]);
    });
  }

  Future<int> excluirDespesa(int id) async {
    final db = await database;
    return await db.delete(
      'despesa', 
      where: 'id = ?', 
      whereArgs: [id]);
  }

  Future<int> editarDespesa(Despesa despesa) async {
  final db = await database;
  return await db.update(
    'despesa',
    despesa.toMap(),
    where: 'id = ?',
    whereArgs: [despesa.id],
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
}
