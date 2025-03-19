import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<dynamic> _data = []; // Store fetched data
  String getSanityImageUrl(String ref) {
    if (ref == null || ref.isEmpty) return ''; // Prevent crashes

    // Extract image ID from the _ref field
    final parts = ref.split('-');
    if (parts.length < 4) return ''; // Ensure correct format

    final imageId = parts[1]; // Extract image ID
    final dimensions = parts[2]; // Extract width x height
    final format = parts[3]; // Extract format (jpg, png, etc.)

    return "https://cdn.sanity.io/images/wy0dryv4/production/$imageId-$dimensions.$format";
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the screen loads
  }

  // Fetch data from Next.js API
  // Fetch data from Next.js API
  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://baby-shop-hub-two.vercel.app/api/products'),
      );

      if (response.statusCode == 200) {
        print("Raw API Response: ${response.body}");

        final List<dynamic> jsonData = json.decode(
          response.body,
        ); // ✅ Directly decode as a List

        setState(() {
          _data = jsonData; // ✅ Assign directly
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BabyShopHub')),
      body:
          _data.isEmpty
              ? Center(
                child: CircularProgressIndicator(),
              ) // Show loader if data is empty
              : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  var item = _data[index];

                  return ListTile(
                    leading:
                        (item['images'] != null && item['images'].isNotEmpty)
                            ? Image.network(
                              getSanityImageUrl(
                                item['images'][0]['asset']['_ref'],
                              ),
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      Icon(Icons.broken_image),
                            )
                            : Icon(Icons.image_not_supported),
                    title: Text(item['title'] ?? 'No title'),
                    subtitle: Text(
                      'Price: Rs. ${item['price']?.toString() ?? 'N/A'}',
                    ),
                  );
                },
              ),
    );
  }
}
