class CoreStrings {
  const CoreStrings._();

  static const String stock = 'Estoque';
  static const String productName = 'Nome do produto';
  static const String quantity = 'Quantidade';
  static const String enterBarcode = 'Digite o código de barras';
  static const String addProduct = 'Adicionar o produto';
  static const String barcode = 'Código de barras';

  static const String productDetails = 'Detalhes do Produto';
  static const String productList = 'Lista de Produtos';
  static const String addNewProducts = 'Adicionar novo produto';
  static const String collectFromStock = 'Coletar do estoque';
  static const String emptyProductList = 'Nenhum produto cadastrado';
  static const String loadProductsError = 'Erro ao carregar produtos';
  static const String tryAgain = 'Tentar novamente';
  static const String addedBy = 'Adicionado por';
  static const String productAddedSuccess = 'Produto adicionado com sucesso!';
  static const String productRemovedSuccess = 'Coleta realizada com sucesso!';
  static const String informProductName = 'Informe o nome do produto';
  static const String removeProducts = 'Remover o produto';

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
  static const String settings = 'Configurações';
  static const String appearance = 'Aparência';
  static const String account = 'Conta';
  static const String companyCode = 'Código da empresa';
  static const String companyCodeHint = 'Deixe em branco para criar nova empresa';
  static const String fillAllFields = 'Preencha todos os campos';
  static const String passwordMismatch = 'As senhas não coincidem';

  static const String confirmRemoval = 'Confirmar remoção';
  static const String cancel = 'Cancelar';
  static const String remove = 'Remover';
  static const String codeCopied = 'Código copiado!';
  static const String quantityToRemove = 'Quantidade a remover';
  static const String insufficientStock = 'Quantidade insuficiente em estoque';
  static const String invalidQuantity = 'Informe uma quantidade válida';
  static const String addOnStock = 'Adicionar no estoque';
  static const String deleteProducts = 'Remover produtos';
  static const String productDeletedSuccess = 'Produto removido com sucesso!';
  static const String confirmDeletion = 'Confirmar exclusão';
  static const String delete = 'Excluir';
  static const String stockUpdatedSuccess = 'Estoque atualizado com sucesso!';
  static const String quantityToAdd = 'Quantidade a adicionar';

  static const String lastUpdate = 'Última atualização';
  static const String stockAdded = 'Estoque adicionado por';
  static const String stockCollected = 'Estoque coletado por';

  static String nameOf(String name) => 'Nome: $name';
  static String quantityOf(int? quantity) => 'Quantidade: $quantity';
  static String barcodeOf(Object? barcode) => 'Código de Barras: $barcode';
  static String confirmRemovalOf(String name) => 'Deseja remover "$name"?';
}