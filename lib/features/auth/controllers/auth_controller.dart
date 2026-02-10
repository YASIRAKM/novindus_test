import 'package:flutter/material.dart';
import 'package:novindus_tets/features/auth/services/auth_service.dart';


class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkLoginStatus() async {
    final token = await _authService.getToken();
    if (token != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final (success, message) = await _authService.login(username, password);

    _isLoading = false;
    if (success) {
      _isAuthenticated = true;
    } else {
      _errorMessage = message;
      _isAuthenticated = false;
    }
    notifyListeners();
    return success;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
