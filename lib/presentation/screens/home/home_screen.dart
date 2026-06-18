import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_assets.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/auth/auth_events.dart';
import 'package:storage_test/presentation/blocs/auth/auth_state.dart';
import 'package:storage_test/presentation/blocs/theme/theme_cubit.dart';
import 'package:storage_test/presentation/routes/app_routes.dart';
import 'package:storage_test/presentation/screens/home/widgets/home_menu_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          CoreStrings.stock,
          style: CoreFonts.title,
        ),
      ),
      drawer: Drawer(
        child: Column(
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
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticatedState &&
                    state.user.companyCode != null) {
                  return ListTile(
                    leading: const Icon(Icons.business_outlined),
                    title: const Text(CoreStrings.companyCode),
                    subtitle: Text(
                      state.user.companyCode!,
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
                            ClipboardData(text: state.user.companyCode!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Código copiado!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const Divider(height: 1),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined),
                  title: const Text(CoreStrings.darkTheme),
                  value: themeMode == ThemeMode.dark,
                  onChanged: (isDark) =>
                      context.read<ThemeCubit>().toggleTheme(isDark),
                );
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(CoreStrings.logout),
              onTap: () {
                Navigator.of(context).pop();
                context.read<AuthBloc>().add(LogoutEvent());
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
