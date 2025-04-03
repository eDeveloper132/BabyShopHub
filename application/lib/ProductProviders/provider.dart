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

  // Utility function to get product video URL
  static String getSanityVideoUrl(String ref) {
    if (ref.isEmpty) return '';
    final parts = ref.split('-');
    if (parts.length < 4) return '';
    final videoId = parts[1];
    final dimensions = parts[2];
    final format = parts[3];
    print("$videoId $dimensions $format");
    // Assuming videos use a similar CDN structure; adjust if different
    return "https://cdn.sanity.io/files/wy0dryv4/production/$videoId-$dimensions.$format";
  }

  // New method to fetch all image and video URLs
  static Future<Map<String, List<String>>> fetchMediaUrls() async {
    try {
      // Fetch products first
      final productsList = await fetchProducts();

      // Lists to store URLs
      List<String> imageUrls = [];
      List<String> videoUrls = [];

      // Iterate through each product
      for (var product in productsList) {
        // Extract image URLs
        if (product.images != null && product.images!.isNotEmpty) {
          for (var image in product.images!) {
            if (image.asset?.sRef != null) {
              String imageUrl = getSanityImageUrl(image.asset!.sRef!);
              if (imageUrl.isNotEmpty) {
                imageUrls.add(imageUrl);
              }
            }
          }
        }

        // Extract video URL (single video per product)
        if (product.video != null && product.video!.asset?.sRef != null) {
          String videoUrl = getSanityVideoUrl(product.video!.asset!.sRef!);
          if (videoUrl.isNotEmpty) {
            videoUrls.add(videoUrl);
          }
        }
      }

      // Return a map with image and video URLs
      return {'images': imageUrls, 'videos': videoUrls};
    } catch (e) {
      print('Error fetching media URLs: $e');
      return {'images': [], 'videos': []}; // Return empty lists on error
    }
  }
}
