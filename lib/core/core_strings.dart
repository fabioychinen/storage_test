class CoreStrings {
  const CoreStrings._();

  static const String stock = 'Estoque';
  static const String productName = 'Nome do produto';
  static const String quantity = 'Quantidade';
  static const String enterBarcode = 'Digite o código de barras';
  static const String addProduct = 'Adicionar produto';
  static const String barcode = 'Código de barras';

  static const String productDetails = 'Detalhes do Produto';
  static const String productList = 'Lista de Produtos';
  static const String addProducts = 'Adicionar produtos';
  static const String removeProducts = 'Remover produtos';
  static const String cancel = 'Cancelar';
  static const String invalid = 'Inválido';
  static const String scan = 'Escanear';

  static String nameOf(String name) => 'Nome: $name';
  static String quantityOf(int? quantity) => 'Quantidade: $quantity';
  static String barcodeOf(Object? barcode) => 'Código de Barras: $barcode';
}
