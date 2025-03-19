import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<dynamic> _data = []; // Store fetched data

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the screen loads
  }

  // Fetch data from Next.js API
  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://baby-shop-hub-two.vercel.app/api/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _data = jsonData;
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
                              item['images'][0]['url'],
                            ) // Adjust based on API response
                            : Icon(Icons.image_not_supported), // Fallback icon
                    title: Text(item['title'] ?? 'No title'),
                    subtitle: Text('Price: Rs. ${item['price'] ?? 'N/A'}'),
                  );
                },
              ),
    );
  }
}
