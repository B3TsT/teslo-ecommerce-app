//* Clase para cambiar la pagina y redibujarla

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';

final goRouterNotifierProvider = Provider<GoRouterNotifier>((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});

class GoRouterNotifier extends ChangeNotifier {
  GoRouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      setAuthStatus = state.authStatus;
    });
  }
  final AuthNotifier _authNotifier;
  AuthStatus _authStatus = AuthStatus.checking;

  AuthStatus get authStatus => _authStatus;

  set setAuthStatus(AuthStatus value) {
    if (_authStatus == value) return;
    _authStatus = value;
    notifyListeners();
  }
}
