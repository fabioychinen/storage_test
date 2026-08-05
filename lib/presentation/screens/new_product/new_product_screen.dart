import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/domain/entities/product.dart';
import 'package:storage_test/presentation/blocs/barcode/barcode_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/blocs/product/product_state.dart';
import 'package:storage_test/presentation/screens/barcode/barcode_screen.dart';

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final _productController = TextEditingController();
  final _quantityController = TextEditingController();
  final _barcodeController = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _productController.text.trim();
    if (name.isEmpty) {
      _showSnackBar(CoreStrings.informProductName, isError: true);
      return;
    }

    final product = Product(
      name: name,
      quantity: int.tryParse(_quantityController.text) ?? 0,
      barcode: int.tryParse(_barcodeController.text) ?? 0,
    );

    setState(() => _isAdding = true);
    context.read<ProductBloc>().add(AddProductEvent(product));
  }

  void _clearFields() {
    _productController.clear();
    _quantityController.clear();
    _barcodeController.clear();
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  InputDecoration _decorationFor(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (!_isAdding) return;
            setState(() => _isAdding = false);
            if (state is ProductSuccessState) {
              _clearFields();
              _showSnackBar(CoreStrings.productAddedSuccess, isError: false);
            } else if (state is ProductErrorState) {
              _showSnackBar(state.message, isError: true);
            }
          },
        ),
        BlocListener<BarcodeBloc, String>(
          listener: (context, barcode) {
            if (barcode.isNotEmpty) {
              _barcodeController.text = barcode;
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(CoreStrings.stock, style: CoreFonts.title),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _productController,
                textInputAction: TextInputAction.next,
                decoration: _decorationFor(
                  CoreStrings.productName,
                  Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: _decorationFor(
                  CoreStrings.quantity,
                  Icons.numbers_outlined,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _barcodeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: _decorationFor(
                  CoreStrings.enterBarcode,
                  Icons.qr_code_2_outlined,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isAdding ? null : _submit,
                  icon: _isAdding
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add),
                  label: const Text(
                    CoreStrings.addProduct,
                    style: CoreFonts.body,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isAdding
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const BarCodeScreen(),
                            ),
                          ),
                  icon: const Icon(Icons.qr_code_scanner_outlined),
                  label: const Text(
                    CoreStrings.barcode,
                    style: CoreFonts.body,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}