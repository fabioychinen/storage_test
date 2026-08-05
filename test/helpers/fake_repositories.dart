import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/domain/entities/user.dart';
import 'package:storage_test/domain/repositories/auth_repository.dart';
import 'package:storage_test/domain/repositories/product_repository.dart';

class FakeProductRepository implements ProductRepository {
  FakeProductRepository({List<Product>? initial}) {
    if (initial != null) _products.addAll(initial);
  }

  final List<Product> _products = [];
  int _nextId = 1;

  @override
  Future<List<Product>> loadProducts() async => List.of(_products);

  @override
  Future<Product> addProduct(Product product) async {
    final added = Product(
      id: _nextId++,
      name: product.name,
      quantity: product.quantity,
      barcode: product.barcode,
    );
    _products.add(added);
    return added;
  }

  @override
  Future<void> increaseProductQuantity(int id, int amount) async {
    final i = _products.indexWhere((p) => p.id == id);
    if (i == -1) return;
    final p = _products[i];
    _products[i] = Product(
      id: p.id,
      name: p.name,
      quantity: (p.quantity ?? 0) + amount,
      barcode: p.barcode,
    );
  }

  @override
  Future<void> collectProduct(int id, int amount) async {
    final i = _products.indexWhere((p) => p.id == id);
    if (i == -1) return;
    final p = _products[i];
    _products[i] = Product(
      id: p.id,
      name: p.name,
      quantity: (p.quantity ?? 0) - amount,
      barcode: p.barcode,
    );
  }

  @override
  Future<void> deleteProduct(int id) async {
    _products.removeWhere((p) => p.id == id);
  }
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.user});

  final User? user;

  @override
  Future<User?> login(String email, String password) async => user;

  @override
  Future<User> register(String email, String password, {String? companyCode, String? companyName}) async => user!;

  @override
  Future<void> logout() async {}

  @override
  Future<User?> getLoggedUser() async => user;
}