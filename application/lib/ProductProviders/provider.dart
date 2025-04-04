import 'package:application/Types/Product_Type.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  // URL of the API to fetch products
  static const String _apiUrl =
      'https://baby-shop-hub-two.vercel.app/api/outfits';
  static const String _apiUrl_2 =
      'https://baby-shop-hub-two.vercel.app/api/innerwears';
  static const String _apiUrl_3 =
      'https://baby-shop-hub-two.vercel.app/api/toys';
  static const String _apiUrl_4 =
      'https://baby-shop-hub-two.vercel.app/api/watches';
  static const String _apiUrl_5 =
      'https://baby-shop-hub-two.vercel.app/api/slider';

  static Future<List<Products>> fetchSlider() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl_5));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Products.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<List<Products>> fetchWatches() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl_4));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Products.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<List<Products>> fetchToys() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl_3));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Products.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  static Future<List<Products>> fetchInnerwear() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl_2));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Products.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  // Fetch products data from the API
  static Future<List<Products>> fetchOutfits() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => Products.fromJson(item)).toList();
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
    if (ref.isEmpty) return ''; // Handle empty input
    final parts = ref.split('-'); // Split the reference by hyphens
    if (parts.length < 3) {
      // Check if there are at least 3 parts
      print('Invalid video ref format: $parts');
      return '';
    }
    final videoId =
        parts[1]; // Extract assetId (e.g., 139d79ed16a02fa2a5938a568848cee591529a54)
    final format = parts.last; // Extract format (e.g., mp4)
    print('Video ID: $videoId, Format: $format'); // Optional: for debugging
    return "https://cdn.sanity.io/files/wy0dryv4/production/$videoId.$format"; // Construct URL
  }

  // New method to fetch all image and video URLs
  static Future<Map<String, List<String>>> fetchMediaUrls() async {
    try {
      // Fetch products first
      final productsList = await fetchOutfits();

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
