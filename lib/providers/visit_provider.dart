import 'package:flutter/material.dart';
import 'package:aqar_morocco_mobile/core/network/api_client.dart';

class VisitProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  bool _loading = false;
  List<dynamic> _myRequests = [];
  List<dynamic> _ownerVisits = [];

  bool get loading => _loading;
  List<dynamic> get myRequests => _myRequests;
  List<dynamic> get ownerVisits => _ownerVisits;

  Future<bool> createVisitRequest(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      await _apiClient.dio.post('/visits', data: data);
      return true;
    } catch (e) {
      print('Error creating visit request: $e');
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMyRequests() async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _apiClient.dio.get('/visits/my-requests');
      _myRequests = response.data;
    } catch (e) {
      print('Error fetching my requests: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> fetchOwnerVisits() async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _apiClient.dio.get('/visits/owner-visits');
      _ownerVisits = response.data;
    } catch (e) {
      print('Error fetching owner visits: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> updateVisitStatus(String id, String status) async {
    try {
      await _apiClient.dio.patch('/visits/$id/status', data: {'status': status});
      await fetchOwnerVisits(); // Refresh
      return true;
    } catch (e) {
      print('Error updating visit status: $e');
      return false;
    }
  }
}
