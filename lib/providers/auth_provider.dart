import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aqar_morocco_mobile/core/network/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  bool _isAuthenticated = false;
  Map<String, dynamic>? _user;
  bool _loading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get user => _user;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _apiClient.dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response.data['access_token']);
      _user = response.data['user'];
      _isAuthenticated = true;
      return true;
    } catch (e) {
      _errorMessage = 'Identifiants incorrects';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required List<String> appRoles,
  }) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _apiClient.dio.post('/auth/register', data: {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'app_roles': appRoles,
      });
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', response.data['access_token']);
      _user = response.data['user'];
      _isAuthenticated = true;
      return true;
    } catch (e) {
      if (e is DioException && e.response?.data != null) {
        final msg = e.response?.data['message'];
        _errorMessage = msg is List ? msg.first : (msg ?? 'Erreur lors de l\'inscription');
      } else {
        _errorMessage = 'Erreur de connexion au serveur';
      }
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUser(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _apiClient.dio.patch('/users/profile', data: data);
      _user = response.data;
      notifyListeners();
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    _isAuthenticated = false;
    _user = null;
    notifyListeners();
  }
}
