import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio();

  // Fetch mocktails by search query
  Future<List<dynamic>> fetchCocktails(String query) async {
    try {
      final response = await _dio.get('https://thecocktaildb.com/api/json/v1/1/search.php?s=$query');
      if (response.statusCode == 200 && response.data['drinks'] != null) {
        return response.data['drinks'];
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching cocktails: $e');
      }
      return [];
    }
  }
}