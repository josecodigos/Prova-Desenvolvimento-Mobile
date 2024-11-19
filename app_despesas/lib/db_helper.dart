import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'despesa.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'agendaFinanceira.db');

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
            data TEXT,
          );
          CREATE TABLE receita (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            valor DOUBLE,
          );
        ''');
      },
    );
  }

  Future<int> insertDespesa(String titulo, String descricao, double valor, DateTime data) async {
    final db = await database;
    return await db.insert('despesa', despesa.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
    return await db.delete('despesa', where: 'id = ?', whereArgs: [id]);
  }
}
