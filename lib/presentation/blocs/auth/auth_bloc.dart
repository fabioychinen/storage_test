import 'package:bloc/bloc.dart';
import 'package:storage_test/core/app_logger.dart';
import 'package:storage_test/domain/usecases/get_logged_user.dart';
import 'package:storage_test/domain/usecases/login.dart';
import 'package:storage_test/domain/usecases/logout.dart';
import 'package:storage_test/domain/usecases/register.dart';
import 'package:storage_test/presentation/blocs/auth/auth_events.dart';
import 'package:storage_test/presentation/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login _login;
  final Register _register;
  final Logout _logout;
  final GetLoggedUser _getLoggedUser;

  AuthBloc({
    required Login login,
    required Register register,
    required Logout logout,
    required GetLoggedUser getLoggedUser,
  })  : _login = login,
        _register = register,
        _logout = logout,
        _getLoggedUser = getLoggedUser,
        super(AuthInitialState()) {
    on<CheckAuthEvent>((event, emit) async {
      emit(AuthLoadingState());
      appLogger.i('Verificando autenticação');
      final user = await _getLoggedUser();
      if (user != null) {
        emit(AuthAuthenticatedState(user: user));
      } else {
        emit(AuthUnauthenticatedState());
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      appLogger.i('LoginEvent: ${event.email}');
      try {
        final user = await _login(event.email, event.password);
        if (user != null) {
          emit(AuthAuthenticatedState(user: user));
        } else {
          emit(AuthErrorState(message: 'E-mail ou senha inválidos'));
        }
      } catch (e) {
        emit(AuthErrorState(message: 'E-mail ou senha inválidos'));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      appLogger.i('RegisterEvent: ${event.email}');
      try {
        final user = await _register(
          event.email,
          event.password,
          companyCode: event.companyCode,
        );
        emit(AuthAuthenticatedState(user: user));
      } catch (e) {
        final message = e.toString().contains('inválido')
            ? 'Código de empresa inválido'
            : 'Erro ao criar conta. Tente outro e-mail.';
        emit(AuthErrorState(message: message));
      }
    });

    on<LogoutEvent>((event, emit) async {
      appLogger.i('LogoutEvent');
      await _logout();
      emit(AuthUnauthenticatedState());
    });

    add(CheckAuthEvent());
  }
}
