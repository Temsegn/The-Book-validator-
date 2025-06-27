import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;

  Future<bool> login(String email, String password) async {
    _setLoading(true);

    try {
      final response = await ApiService.login(email, password);
      print('Login response: $response');

      if (response['success'] == true) {
        _user = User.fromJson(response['user']);
        ApiService.setToken(response['token']);
        _setLoading(false);
        return true;
      } else {
        print('Login failed: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Login exception: $e');
    }

    _setLoading(false);
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);

    try {
      final response = await ApiService.register(name, email, password);
      print('Register response: $response');

      if (response['success'] == true) {
        _user = User.fromJson(response['user']);
        ApiService.setToken(response['token']);
        _setLoading(false);
        return true;
      } else {
        print('Register failed: ${response['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Register exception: $e');
    }

    _setLoading(false);
    return false;
  }

  void logout() {
    _user = null;
    ApiService.setToken('');
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
