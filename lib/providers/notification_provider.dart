import 'package:flutter/material.dart';
import 'package:aqar_morocco_mobile/core/network/api_client.dart';

class NotificationProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  bool _loading = false;
  List<dynamic> _notifications = [];

  bool get loading => _loading;
  List<dynamic> get notifications => _notifications;
  int get unreadCount => _notifications.where((n) => n['is_read'] == false).length;

  Future<void> fetchNotifications() async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _apiClient.dio.get('/notifications');
      _notifications = response.data;
    } catch (e) {
      print('Error fetching notifications: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _apiClient.dio.patch('/notifications/$id/read');
      await fetchNotifications(); // Refresh
    } catch (e) {
      print('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiClient.dio.post('/notifications/read-all');
      await fetchNotifications(); // Refresh
    } catch (e) {
      print('Error marking all notifications as read: $e');
    }
  }
}
