import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'ProductProviders/singleProvider.dart';
import 'ProductProviders/provider.dart';
import '../Types/Product_Type.dart';
import '../cart.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productId =
        Provider.of<SingleServiceProvider>(context).selectedProductId;

    return Scaffold(
      appBar: AppBar(title: Text("Product Details")),
      body: FutureBuilder<List<products>>(
        future: ProductService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            products? product;
            try {
              product = snapshot.data!.firstWhere((p) => p.sId == productId);
            } catch (e) {
              product = null;
            }
            if (product == null) {
              return Center(child: Text('Product not found'));
            }

            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    ProductService.getSanityImageUrl(
                      (product.images != null && product.images!.isNotEmpty)
                          ? product.images![0].asset!.sRef!
                          : '',
                    ),
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    product.title ?? 'No Title',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Price: Rs. ${product.price?.toString() ?? 'N/A'}",
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(height: 20),
                  Text(
                    product.description ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      await saveProductToSharedPreferences(product!);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShoppingCartPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                    ),
                    child: Text(
                      "Add to Cart & Checkout",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No product details available.'));
          }
        },
      ),
    );
  }

  Future<void> saveProductToSharedPreferences(products product) async {
    final prefs = await SharedPreferences.getInstance();
    // Get existing list, if any.
    final String? existingJson = prefs.getString('cart_product');
    List<dynamic> productList = [];
    if (existingJson != null) {
      var decoded = jsonDecode(existingJson);
      if (decoded is List) {
        productList = decoded;
      } else if (decoded is Map) {
        productList = [decoded];
      }
    }
    // Create a new product map.
    Map<String, dynamic> productMap = {
      'sId': product.sId,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'image':
          (product.images != null && product.images!.isNotEmpty)
              ? product.images![0].asset!.sRef
              : '',
      'quantity': 1,
    };
    productList.add(productMap);
    await prefs.setString('cart_product', jsonEncode(productList));
    print('Product saved to SharedPreferences as list of objects');
  }
}
