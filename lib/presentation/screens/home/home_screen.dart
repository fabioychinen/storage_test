import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_assets.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/auth/auth_state.dart';
import 'package:storage_test/presentation/routes/app_routes.dart';
import 'package:storage_test/presentation/screens/home/widgets/home_menu_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    if (index == 0 || index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    switch (index) {
      case 1:
        Navigator.pushNamed(context, AppRoutes.productListScreen)
            .then((_) => setState(() => _selectedIndex = 0));
      case 2:
        Navigator.pushNamed(context, AppRoutes.updateStockScreen)
            .then((_) => setState(() => _selectedIndex = 0));
      case 3:
        Navigator.pushNamed(context, AppRoutes.collectProductScreen)
            .then((_) => setState(() => _selectedIndex = 0));
      case 4:
        Navigator.pushNamed(context, AppRoutes.settingsScreen)
            .then((_) => setState(() => _selectedIndex = 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isAdmin = authState is AuthAuthenticatedState && authState.user.isAdmin;

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(CoreStrings.stock, style: CoreFonts.title),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onNavTap,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Início',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_alt_outlined),
                selectedIcon: Icon(Icons.list_alt),
                label: 'Produtos',
              ),
              NavigationDestination(
                icon: Icon(Icons.move_to_inbox_outlined),
                selectedIcon: Icon(Icons.move_to_inbox),
                label: 'Entrada',
              ),
              NavigationDestination(
                icon: Icon(Icons.outbox_outlined),
                selectedIcon: Icon(Icons.outbox),
                label: 'Saída',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Config.',
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: colorScheme.primary),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      CoreStrings.stock,
                      style: CoreFonts.title.copyWith(
                        color: colorScheme.onPrimary,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                if (authState is AuthAuthenticatedState &&
                    authState.user.companyCode != null)
                  ListTile(
                    leading: const Icon(Icons.business_outlined),
                    title: const Text(CoreStrings.companyCode),
                    subtitle: Text(
                      authState.user.companyCode!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    trailing: IconButton(
                      tooltip: 'Copiar código',
                      icon: const Icon(Icons.copy_outlined),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: authState.user.companyCode!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(CoreStrings.codeCopied),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.list_alt_outlined),
                  title: const Text(CoreStrings.productList),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.productListScreen);
                  },
                ),
                if (isAdmin)
                  ListTile(
                    leading: const Icon(Icons.add_box_outlined),
                  title: const Text(CoreStrings.addProduct),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.newProductScreen);
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.move_to_inbox_outlined),
                  title: const Text(CoreStrings.addOnStock),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.updateStockScreen);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.outbox_outlined),
                  title: const Text(CoreStrings.collectFromStock),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                        context, AppRoutes.collectProductScreen);
                  },
                ),
                if (isAdmin)
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: const Text(CoreStrings.deleteProducts),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                          context, AppRoutes.removeProductScreen);
                    },
                  ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text(CoreStrings.settings),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.settingsScreen);
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                HomeMenuButton(
                  label: CoreStrings.productList,
                  iconAsset: CoreAssets.list,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AppRoutes.productListScreen),
                ),
                const SizedBox(height: 16),
                if (isAdmin) ...[
                  HomeMenuButton(
                    label: CoreStrings.addNewProducts,
                    iconAsset: CoreAssets.addList,
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AppRoutes.newProductScreen),
                  ),
                  const SizedBox(height: 16),
                ],
                HomeMenuButton(
                  label: CoreStrings.addOnStock,
                  iconAsset: CoreAssets.addList,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AppRoutes.updateStockScreen),
                ),
                const SizedBox(height: 16),
                HomeMenuButton(
                  label: CoreStrings.collectFromStock,
                  iconAsset: CoreAssets.collectList,
                  onPressed: () => Navigator.of(context)
                      .pushNamed(AppRoutes.collectProductScreen),
                ),
                if (isAdmin) ...[
                  const SizedBox(height: 16),
                  HomeMenuButton(
                    label: CoreStrings.deleteProducts,
                    iconAsset: CoreAssets.delete,
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AppRoutes.removeProductScreen),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}