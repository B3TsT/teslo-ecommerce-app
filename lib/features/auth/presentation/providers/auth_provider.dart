import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

import '../../../shared/infrastructure/services/key_value_storage_impl.dart';
import '../../../shared/infrastructure/services/key_value_storage_service.dart';
import '../../domain/domain.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

//* AuthProvider primarily used in main.dart
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) {
    final authRepository = AuthRepositoryImpl();
    final keyValueStorageService = KeyValueStorageServiceImpl();
    return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService,
    );
  },
);

//* AuthProvider secondary used in AuthProvider
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }) : super(AuthState()) {
    checkAuthStatus();
  }
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(seconds: 3));
    try {
      final user = await authRepository.login(email, password);
      _setLoggedInUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error no controlado');
    }
    // final user = await authRepository.login(email, password);
    // state = state.copyWith(
    //   authStatus: AuthStatus.checking,
    //   user: user,
    //   errorMessage: '',
    // );
  }

  void registerUser(User user) {
    state = state.copyWith(user: user);
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    if (token == null) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedInUser(user);
    } catch (e) {
      logout();
    }
  }

  _setLoggedInUser(User user) async {
    await keyValueStorageService.setKeyValue(
        'token', user.token); //* <-- set token in shared preferences or hive
    state = state.copyWith(
      authStatus: AuthStatus.authenticated,
      user: user,
      errorMessage: '',
    );
  }

  void logout([String? errorMessage]) async {
    await keyValueStorageService.removeValue(
        'token'); //* <-- remove token from shared preferences or hive
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticated,
      user: null,
      errorMessage: errorMessage,
    );
  }
}

//* AuthState primarily used in AuthProvider
class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
