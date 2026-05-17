import 'package:flutter_application_1/models/product_model.dart';
import 'package:flutter_application_1/models/news_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class ApiService {
  Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse('https://wantapi.com/news.php'));
      
      developer.log('API Response Status: ${response.statusCode}', name: 'ApiService');
      developer.log('API Response Body: ${response.body}', name: 'ApiService');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        
        if (!jsonData.containsKey('data')) {
          throw Exception('API yanıtında "data" alanı bulunamadı');
        }
        
        final List list = jsonData["data"] as List;
        
        if (list.isEmpty) {
          developer.log('API data list boş', name: 'ApiService');
          return [];
        }
        
        return list.map((item) => NewsModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception("Haberler alınırken bir hata oluştu: ${response.statusCode}\nBody: ${response.body}");
      }
    } catch (e) {
      developer.log('fetchNews error: $e', name: 'ApiService', level: 1000);
      rethrow;
    }
  }

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://wantapi.com/products.php'));

      developer.log('Products API Status: ${response.statusCode}', name: 'ApiService');
      developer.log('Products API Body: ${response.body}', name: 'ApiService');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        if (!jsonData.containsKey('data')) {
          throw Exception('API yanıtında "data" alanı bulunamadı');
        }

        final List list = jsonData['data'] as List;

        if (list.isEmpty) {
          developer.log('Products API data list boş', name: 'ApiService');
          return [];
        }

        return list
            .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Ürünler alınırken bir hata oluştu: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      developer.log('fetchProducts error: $e', name: 'ApiService', level: 1000);
      rethrow;
    }
  }
}