import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
//import 'package:storage_test/data/product_db.dart';
import 'package:storage_test/models/product.dart';
import 'package:sqflite/sqflite.dart';

class ProductRepository extends ChangeNotifier {
  late Database _database;

  ProductRepository() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    _database = await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'storage.db');
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
          )
        ''');
      },
    );
  }

  Future<List<Product>> loadProducts() async {
    final List<Map<String, dynamic>> productMaps =
        await _database.query('products');
    return List.generate(productMaps.length, (i) {
      return Product(
        id: productMaps[i]['id'] != null
            ? int.tryParse(productMaps[i]['id'].toString())
            : null,
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
    final id = await _database.insert('products', product.toMap());

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
