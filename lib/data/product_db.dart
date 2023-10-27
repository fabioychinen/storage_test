import 'package:path/path.dart';
//import 'package:storage_test/data/data_general_constant.dart';
//import 'package:storage_test/data/data_product_constant.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:storage_test/data/domain/entities/product_entity.dart';

class ProductDB {
  ProductDB._();
  final productDb = ProductDB._();
  static final ProductDB instance = ProductDB._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'storage.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_product);
  }

  String get _product => '''
    CREATE TABLE product (
      productid INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      quantity INT,
      barcode INT
    );
  ''';
}
