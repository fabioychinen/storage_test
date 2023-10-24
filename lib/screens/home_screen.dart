import 'package:flutter/material.dart';
import 'package:storage_test/utils/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: const Color.fromARGB(192, 78, 78, 78),
        title: const Text(
          'Estoque',
          style: TextStyle(
              fontFamily: 'RussoOne',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(10, 10, 10, 1)),
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
                  'Lista de produtos',
                  style: TextStyle(
                      fontFamily: 'RussoOne',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(10, 10, 10, 1)),
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
                  'Adicionar produtos',
                  style: TextStyle(
                      fontFamily: 'RussoOne',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(10, 10, 10, 1)),
                ),
              ),
            ),
            const SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: null,
                child: Text(
                  'Remover produtos',
                  style: TextStyle(
                      fontFamily: 'RussoOne',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(10, 10, 10, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
