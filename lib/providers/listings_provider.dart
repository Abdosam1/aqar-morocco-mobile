import 'package:flutter/material.dart';
import 'package:aqar_morocco_mobile/core/network/api_client.dart';
import 'package:aqar_morocco_mobile/data/models/listing_model.dart';

class ListingsProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient();
  List<ListingModel> _listings = [];
  bool _loading = false;

  List<ListingModel> get listings => _listings;
  bool get loading => _loading;

  Future<void> fetchListings({Map<String, dynamic>? filters}) async {
    _loading = true;
    notifyListeners();
    try {
      final response = await _apiClient.dio.get('/listings', queryParameters: filters);
      final List data = response.data['data'];
      _listings = data.map((l) => ListingModel.fromJson(l)).toList();
    } catch (e) {
      print('Error fetching listings: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> createListing(Map<String, dynamic> data) async {
    _loading = true;
    notifyListeners();
    try {
      await _apiClient.dio.post('/listings', data: data);
      await fetchListings(); // Refresh the list
      return true;
    } catch (e) {
      print('Error creating listing: $e');
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
