import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:storage_test/models/product.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository extends ChangeNotifier {
  late Database _database;

  ProductRepository({String? databasePath}) {
    initDatabase(databasePath);
  }

  void initDatabase(String? databasePath) async {
    _database = await _initDatabase(databasePath);
  }

  Future<Database> _initDatabase(String? databasePath) async {
    if (databasePath == null) {
      databasePath = await getDatabasesPath();
      databasePath = join(databasePath, 'storage.db');
    }

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            quantity INT,
            barcode INT
          ); 
        ''');
      },
    );
  }

  Future<List<Product>> loadProducts() async {
    final List<Map<String, dynamic>> productMaps =
        await _database.query('products');
    return List.generate(productMaps.length, (i) {
      return Product(
        name: productMaps[i]['name'] as String,
        quantity: productMaps[i]['quantity'] != null
            ? int.tryParse(productMaps[i]['quantity'].toString())
            : null,
        barcode: productMaps[i]['barcode'] != null
            ? int.tryParse(productMaps[i]['barcode'].toString())
            : null,
      );
    });
  }

  Future<Product> addProduct(Product product) async {
    final id = await _database.insert('products', product.toMapWithoutId());

    product = product.copyWith(id: id);
    notifyListeners();
    return product;
  }

  Future<void> removeProduct(int id) async {
    try {
      await _database.delete('products', where: 'id = ?', whereArgs: [id]);
      notifyListeners();
    } catch (e) {
      return;
    }
  }
}
