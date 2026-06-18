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
    add(CheckAuthEvent());

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
      appLogger.i('LoginEvent: ${event.username}');
      final user = await _login(event.username, event.password);
      if (user != null) {
        emit(AuthAuthenticatedState(user: user));
      } else {
        emit(AuthErrorState(message: 'Usuário ou senha inválidos'));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      appLogger.i('RegisterEvent: ${event.username}');
      try {
        final user = await _register(event.username, event.password);
        emit(AuthAuthenticatedState(user: user));
      } catch (e) {
        emit(AuthErrorState(message: 'Usuário já cadastrado'));
      }
    });

    on<LogoutEvent>((event, emit) async {
      appLogger.i('LogoutEvent');
      await _logout();
      emit(AuthUnauthenticatedState());
    });
  }
}
