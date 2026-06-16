import 'package:flutter/material.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/utils/app_routes.dart';

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
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.productListScreen);
                },
                child: const Text(
                  CoreStrings.productList,
                  style: CoreFonts.body,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.newProductScreen);
                },
                child: const Text(
                  CoreStrings.addProducts,
                  style: CoreFonts.body,
                ),
              ),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.productListScreen);
                },
                child: const Text(
                  CoreStrings.removeProducts,
                  style: CoreFonts.body,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
