import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDataSource {
  final String? databasePath;
  Database? _database;

  ProductLocalDataSource({this.databasePath});

  Future<Database> get _db async {
    _database ??= await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final path = databasePath ?? join(await getDatabasesPath(), 'storage.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity INTEGER,
            barcode INTEGER
          );
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> queryProducts() async {
    final db = await _db;
    return db.query('products');
  }

  Future<int> insertProduct(Map<String, dynamic> values) async {
    final db = await _db;
    return db.insert('products', values);
  }

  Future<void> deleteProduct(int id) async {
    final db = await _db;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
