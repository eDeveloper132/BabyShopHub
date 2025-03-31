import 'package:application/Types/Classes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataScreen extends StatefulWidget {
  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<products> _data = [];

  String getSanityImageUrl(String ref) {
    if (ref == null || ref.isEmpty) return '';
    final parts = ref.split('-');
    if (parts.length < 4) return '';
    final imageId = parts[1];
    final dimensions = parts[2];
    final format = parts[3];
    return "https://cdn.sanity.io/images/wy0dryv4/production/$imageId-$dimensions.$format";
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://baby-shop-hub-two.vercel.app/api/products'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          _data = jsonData.map((item) => products.fromJson(item)).toList();
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Widget _buildProductTile(products product) {
    return ListTile(
      leading:
          (product.images != null && product.images!.isNotEmpty)
              ? Image.network(
                getSanityImageUrl(product.images![0].asset!.sRef!),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder:
                    (context, error, stackTrace) => Icon(Icons.broken_image),
              )
              : Icon(Icons.image_not_supported),
      title: Text(product.title ?? 'No title'),
      subtitle: Text('Price: Rs. ${product.price?.toString() ?? 'N/A'}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BabyShopHub')),
      body:
          _data.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  return _buildProductTile(_data[index]);
                },
              ),
    );
  }
}
