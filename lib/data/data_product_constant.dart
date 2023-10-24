const String databaseName = 'storage_db';

const String productTableName = 'products';
const String productColumnProductId = 'productID';
const String productColumnName = 'name';
const String productColumnQuantity = 'quantity';
const String productColumnBarcode = 'barcode';

const String createProductTableScript = '''
CREATE TABLE $productTableName (
  $productColumnProductId INTEGER PRIMARY KEY,
  $productColumnName TEXT,
  $productColumnQuantity INTEGER,
  $productColumnBarcode INTEGER
)
''';
