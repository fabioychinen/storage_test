import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_assets.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/auth/auth_state.dart';
import 'package:storage_test/presentation/blocs/product/product_bloc.dart';
import 'package:storage_test/presentation/blocs/product/product_events.dart';
import 'package:storage_test/presentation/blocs/product/product_state.dart';
import 'package:storage_test/presentation/routes/app_routes.dart';
import 'package:storage_test/presentation/screens/home/widgets/home_menu_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProductEvent());
  }

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
        final isAdmin =
            authState is AuthAuthenticatedState && authState.user.isAdmin;
        final userEmail =
            authState is AuthAuthenticatedState ? authState.user.email : null;
        final companyCode = authState is AuthAuthenticatedState
            ? authState.user.companyCode
            : null;

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
          // Drawer simplificado: perfil + funcionalidades admin
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(color: colorScheme.primary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.2),
                        foregroundColor: colorScheme.onPrimary,
                        child: const Icon(Icons.person),
                      ),
                      const SizedBox(height: 8),
                      if (userEmail != null)
                        Text(
                          userEmail,
                          style: TextStyle(
                              color: colorScheme.onPrimary, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (isAdmin)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                colorScheme.onPrimary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Admin',
                            style: TextStyle(
                                color: colorScheme.onPrimary, fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                ),
                if (companyCode != null) ...[
                  ListTile(
                    leading: const Icon(Icons.business_outlined),
                    title: const Text(CoreStrings.companyCode),
                    subtitle: Text(
                      companyCode,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 2),
                    ),
                    trailing: IconButton(
                      tooltip: 'Copiar código',
                      icon: const Icon(Icons.copy_outlined),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: companyCode));
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
                ],
                if (isAdmin) ...[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'Administração',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.add_box_outlined),
                    title: const Text(CoreStrings.addProduct),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AppRoutes.newProductScreen);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_outline,
                        color: colorScheme.error),
                    title: Text(CoreStrings.deleteProducts,
                        style: TextStyle(color: colorScheme.error)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                          context, AppRoutes.removeProductScreen);
                    },
                  ),
                  const Divider(height: 1),
                ],
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card de boas-vindas + resumo do estoque
                Card(
                  elevation: 0,
                  color: colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CoreStrings.welcomeTitle,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (userEmail != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            userEmail,
                            style: TextStyle(
                                color: colorScheme.outline, fontSize: 13),
                          ),
                        ],
                        const SizedBox(height: 16),
                        BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, productState) {
                            final count = productState is ProductSuccessState
                                ? productState.products.length
                                : null;
                            return Row(
                              children: [
                                Icon(Icons.inventory_2_outlined,
                                    color: colorScheme.primary, size: 20),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    CoreStrings.totalProducts,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                count != null
                                    ? Text(
                                        '$count',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: colorScheme.primary,
                                        ),
                                      )
                                    : const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                if (isAdmin) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Administração',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  HomeMenuButton(
                    label: CoreStrings.addNewProducts,
                    iconAsset: CoreAssets.addList,
                    accentColor: colorScheme.secondary,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.newProductScreen),
                  ),
                  const SizedBox(height: 12),
                  HomeMenuButton(
                    label: CoreStrings.deleteProducts,
                    iconAsset: CoreAssets.delete,
                    accentColor: colorScheme.error,
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AppRoutes.removeProductScreen),
                  ),
                ] else ...[
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.touch_app_outlined,
                          size: 16, color: colorScheme.outline),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Use a barra inferior para navegar',
                          style: TextStyle(
                              color: colorScheme.outline, fontSize: 13),
                        ),
                      ),
                    ],
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
