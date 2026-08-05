import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/auth/auth_events.dart';
import 'package:storage_test/presentation/blocs/theme/theme_cubit.dart';
import 'package:storage_test/presentation/screens/settings/widgets/section_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(CoreStrings.settings, style: CoreFonts.title),
      ),
      body: ListView(
        children: [
          const SectionHeader(CoreStrings.appearance),
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
          const Divider(),
          const SectionHeader(CoreStrings.account),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(CoreStrings.logout),
            textColor: Theme.of(context).colorScheme.error,
            iconColor: Theme.of(context).colorScheme.error,
            onTap: () {
              final authBloc = context.read<AuthBloc>();
              Navigator.of(context).popUntil((route) => route.isFirst);
              authBloc.add(LogoutEvent());
            },
          ),
        ],
      ),
    );
  }
}