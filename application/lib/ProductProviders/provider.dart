import 'package:application/Types/Product_Type.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  // URL of the API to fetch products
  static const String _apiUrl =
      'https://baby-shop-hub-two.vercel.app/api/products';

  // Fetch products data from the API
  static Future<List<products>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => products.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  // Utility function to get product image URL
  static String getSanityImageUrl(String ref) {
    if (ref.isEmpty) return '';
    final parts = ref.split('-');
    if (parts.length < 4) return '';
    final imageId = parts[1];
    final dimensions = parts[2];
    final format = parts[3];
    return "https://cdn.sanity.io/images/wy0dryv4/production/$imageId-$dimensions.$format";
  }
}
