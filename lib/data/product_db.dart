import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductDB {
  ProductDB._();
  static final ProductDB instance = ProductDB._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'storage.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        quantity INT,
        barcode INT
      ); 
    ''');
  }

  Future<void> initDatabase() async {
    await _initDatabase();
  }
}
