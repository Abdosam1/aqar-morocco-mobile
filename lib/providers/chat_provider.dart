import 'package:flutter/material.dart';
import 'package:aqar_morocco_mobile/core/network/api_client.dart';

class ChatProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  bool _loading = false;
  List<dynamic> _conversations = [];
  List<dynamic> _currentThread = [];

  bool get loading => _loading;
  List<dynamic> get conversations => _conversations;
  List<dynamic> get currentThread => _currentThread;

  Future<void> fetchConversations() async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _apiClient.dio.get('/messages/conversations');
      _conversations = response.data;
    } catch (e) {
      print('Error fetching conversations: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchThread(String otherUserId, {String? listingId}) async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _apiClient.dio.get(
        '/messages/thread/$otherUserId',
        queryParameters: listingId != null ? {'listingId': listingId} : {},
      );
      _currentThread = response.data;
    } catch (e) {
      print('Error fetching thread: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> sendMessage({
    required String receiverId,
    required String content,
    String? listingId,
  }) async {
    try {
      final response = await _apiClient.dio.post('/messages', data: {
        'receiver_id': receiverId,
        'content': content,
        'listing_id': listingId,
      });
      // Optimized: Add message locally first or just refresh thread
      _currentThread.add(response.data);
      notifyListeners();
      return true;
    } catch (e) {
      print('Error sending message: $e');
      return false;
    }
  }

  Future<void> markAsRead(String messageId) async {
    try {
      await _apiClient.dio.patch('/messages/$messageId/read');
    } catch (e) {
      print('Error marking as read: $e');
    }
  }
}
