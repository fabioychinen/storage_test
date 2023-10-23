import 'package:path/path.dart';
import 'package:storage_test/data/data_general_constant.dart';
import 'package:storage_test/data/data_product_constant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:storage_test/data/domain/entities/product_entity.dart';

class ProductSqliteDatasource {
  // ignore: prefer_typing_uninitialized_variables
  static var instance;

  Future<Database> _getDatabase() async {
    //await deleteDatabase(
    //join(await getDatabasesPath(), databaseName),
    //);

    return openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) async {
        await db.execute(createProductTableScript);
        await db.rawInsert('''insert into $productTableName(
        $productColumnProductId, $productColumnName, $productColumnQuantity, $productColumnBarcode
      ) VALUES ('1,Laranja, 12, 956100234)''');
      },
      version: databaseVersion,
    );
  }

  Future create(ProductEntity product) async {
    try {
      final Database db = await _getDatabase();
      product.productID = await db.rawInsert('''insert into $productTableName(
        $productColumnProductId, $productColumnName, $productColumnQuantity, $productColumnBarcode)
        VALUES ('${product.name}, '${product.quantity},${product.barcode}'
        
        )''');
    } catch (ex) {
      return;
    }
    return product;
  }
}
