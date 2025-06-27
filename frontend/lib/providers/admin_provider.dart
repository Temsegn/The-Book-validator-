import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AdminProvider with ChangeNotifier {
  List<User> _users = [];
  Map<String, dynamic> _analytics = {};
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get users => _users;
  Map<String, dynamic> get analytics => _analytics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final users = await ApiService.getUsers();
      _users = users;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load users: $e';
      print('Error loading users: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAnalytics() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final analytics = await ApiService.getAnalytics();
      _analytics = analytics;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load analytics: $e';
      print('Error loading analytics: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> approveContent(String contentType, String contentId) async {
    try {
      final response = await ApiService.approveContent(contentType, contentId);
      return response['success'] == true;
    } catch (e) {
      print('Error approving content: $e');
      return false;
    }
  }

  Future<bool> rejectContent(String contentType, String contentId, String reason) async {
    try {
      final response = await ApiService.rejectContent(contentType, contentId, reason);
      return response['success'] == true;
    } catch (e) {
      print('Error rejecting content: $e');
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
