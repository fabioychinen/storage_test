import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storage_test/core/core_fonts.dart';
import 'package:storage_test/core/core_strings.dart';
import 'package:storage_test/presentation/blocs/auth/auth_bloc.dart';
import 'package:storage_test/presentation/blocs/auth/auth_events.dart';
import 'package:storage_test/presentation/blocs/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyCodeController = TextEditingController();
  bool _isRegisterMode = false;
  bool _isCreatingCompany = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _companyNameController.dispose();
    _companyCodeController.dispose();
    super.dispose();
  }

  void _submit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError(CoreStrings.fillAllFields);
      return;
    }

    if (_isRegisterMode) {
      final confirm = _confirmPasswordController.text.trim();
      if (password != confirm) {
        _showError(CoreStrings.passwordMismatch);
        return;
      }

      if (_isCreatingCompany) {
        final companyName = _companyNameController.text.trim();
        if (companyName.isEmpty) {
          _showError('Informe o nome da empresa');
          return;
        }
        context.read<AuthBloc>().add(RegisterEvent(
              email: email,
              password: password,
              companyName: companyName,
            ));
      } else {
        final companyCode = _companyCodeController.text.trim();
        if (companyCode.isEmpty) {
          _showError('Informe o código da empresa');
          return;
        }
        context.read<AuthBloc>().add(RegisterEvent(
              email: email,
              password: password,
              companyCode: companyCode,
            ));
      }
    } else {
      context.read<AuthBloc>().add(LoginEvent(email: email, password: password));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _toggleMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      _isCreatingCompany = true;
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _companyNameController.clear();
      _companyCodeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(CoreStrings.stock, style: CoreFonts.title),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            _showError(state.message);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warehouse, size: 80),
                const SizedBox(height: 8),
                Text(
                  _isRegisterMode
                      ? CoreStrings.createAccount
                      : CoreStrings.loginTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: CoreStrings.email,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: _isRegisterMode
                      ? TextInputAction.next
                      : TextInputAction.done,
                  onSubmitted: _isRegisterMode ? null : (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: CoreStrings.password,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: _isRegisterMode
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            TextField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: CoreStrings.confirmPassword,
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () => setState(() =>
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SegmentedButton<bool>(
                              segments: const [
                                ButtonSegment(
                                  value: true,
                                  label: Text(CoreStrings.createNewCompany),
                                  icon: Icon(Icons.add_business_outlined),
                                ),
                                ButtonSegment(
                                  value: false,
                                  label: Text(CoreStrings.joinCompany),
                                  icon: Icon(Icons.business_outlined),
                                ),
                              ],
                              selected: {_isCreatingCompany},
                              onSelectionChanged: (s) => setState(() {
                                _isCreatingCompany = s.first;
                                _companyNameController.clear();
                                _companyCodeController.clear();
                              }),
                            ),
                            const SizedBox(height: 16),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: _isCreatingCompany
                                  ? TextField(
                                      key: const ValueKey('name'),
                                      controller: _companyNameController,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => _submit(),
                                      decoration: const InputDecoration(
                                        labelText: CoreStrings.companyName,
                                        border: OutlineInputBorder(),
                                        prefixIcon:
                                            Icon(Icons.business_outlined),
                                      ),
                                    )
                                  : TextField(
                                      key: const ValueKey('code'),
                                      controller: _companyCodeController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      textInputAction: TextInputAction.done,
                                      onSubmitted: (_) => _submit(),
                                      decoration: const InputDecoration(
                                        labelText: CoreStrings.companyCode,
                                        border: OutlineInputBorder(),
                                        prefixIcon:
                                            Icon(Icons.vpn_key_outlined),
                                      ),
                                    ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoadingState;
                    return SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _isRegisterMode
                                    ? CoreStrings.register
                                    : CoreStrings.login,
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _toggleMode,
                  child: Text(
                    _isRegisterMode
                        ? CoreStrings.alreadyHaveAccount
                        : CoreStrings.createAccount,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
