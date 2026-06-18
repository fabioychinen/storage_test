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
  static const String emptyProductList = 'Nenhum produto cadastrado';

  static const String loginTitle = 'Login';
  static const String username = 'Usuário';
  static const String email = 'E-mail';
  static const String password = 'Senha';
  static const String confirmPassword = 'Confirmar senha';
  static const String login = 'Entrar';
  static const String register = 'Cadastrar';
  static const String createAccount = 'Criar conta';
  static const String alreadyHaveAccount = 'Já tenho uma conta';
  static const String logout = 'Sair';
  static const String darkTheme = 'Tema escuro';
  static const String companyCode = 'Código da empresa';
  static const String companyCodeHint = 'Deixe em branco para criar nova empresa';
  static const String fillAllFields = 'Preencha todos os campos';
  static const String passwordMismatch = 'As senhas não coincidem';

  static String nameOf(String name) => 'Nome: $name';
  static String quantityOf(int? quantity) => 'Quantidade: $quantity';
  static String barcodeOf(Object? barcode) => 'Código de Barras: $barcode';
}
