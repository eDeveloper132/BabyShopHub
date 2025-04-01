import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/singleProvider.dart';
import '../Providers/provider.dart';
import '../Types/Classes.dart';

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
}
