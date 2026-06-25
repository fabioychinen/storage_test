import 'package:flutter/material.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/domain/entities/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  String _formatDate(DateTime date) {
    final d = date.toLocal();
    final day = d.day.toString().padLeft(2, '0');
    final month = d.month.toString().padLeft(2, '0');
    final year = d.year.toString();
    final hour = d.hour.toString().padLeft(2, '0');
    final min = d.minute.toString().padLeft(2, '0');
    return '$day/$month/$year às $hour:$min';
  }

  @override
  Widget build(BuildContext context) {
    final hasLastUpdate = product.lastUpdatedAt != null &&
        product.lastUpdatedByEmail != null &&
        product.lastUpdateType != null;

    final isAdd = product.lastUpdateType == 'add';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          CoreStrings.productDetails,
          style: CoreFonts.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(
                  CoreStrings.nameOf(product.name),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.numbers_outlined),
                title: Text(CoreStrings.quantityOf(product.quantity)),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.qr_code_2_outlined),
                title: Text(CoreStrings.barcodeOf(product.barcode)),
              ),
              if (product.addedByEmail != null) ...[
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.person_add_outlined),
                  title: const Text(CoreStrings.addedBy),
                  subtitle: Text(product.addedByEmail!),
                ),
              ],
              if (hasLastUpdate) ...[
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    isAdd
                        ? Icons.add_circle_outline
                        : Icons.remove_circle_outline,
                    color: isAdd ? Colors.green : Colors.orange,
                  ),
                  title: Text(
                    isAdd
                        ? CoreStrings.stockAdded
                        : CoreStrings.stockCollected,
                  ),
                  subtitle: Text(
                    '${product.lastUpdatedByEmail!}\n${_formatDate(product.lastUpdatedAt!)}',
                  ),
                  isThreeLine: true,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}