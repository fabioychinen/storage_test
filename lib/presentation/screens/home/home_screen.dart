import 'package:flutter/material.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/presentation/routes/app_routes.dart';
import 'package:storage_test/presentation/screens/home/widgets/home_menu_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: const Color.fromARGB(192, 78, 78, 78),
        title: const Text(
          CoreStrings.stock,
          style: CoreFonts.title,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HomeMenuButton(
              label: CoreStrings.productList,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.productListScreen),
            ),
            HomeMenuButton(
              label: CoreStrings.addProducts,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.newProductScreen),
            ),
            HomeMenuButton(
              label: CoreStrings.removeProducts,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.productListScreen),
            ),
          ],
        ),
      ),
    );
  }
}
