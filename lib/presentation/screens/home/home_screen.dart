import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_assets.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/auth/auth_events.dart';
import 'package:storage_test/presentation/routes/app_routes.dart';
import 'package:storage_test/presentation/screens/home/widgets/home_menu_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          CoreStrings.stock,
          style: CoreFonts.title,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: CoreStrings.logout,
            onPressed: () => context.read<AuthBloc>().add(LogoutEvent()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            HomeMenuButton(
              label: CoreStrings.productList,
              iconAsset: CoreAssets.list,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.productListScreen),
            ),
            const SizedBox(height: 16),
            HomeMenuButton(
              label: CoreStrings.addProducts,
              iconAsset: CoreAssets.addList,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.newProductScreen),
            ),
            const SizedBox(height: 16),
            HomeMenuButton(
              label: CoreStrings.removeProducts,
              iconAsset: CoreAssets.delete,
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.productListScreen),
            ),
          ],
        ),
      ),
    );
  }
}
