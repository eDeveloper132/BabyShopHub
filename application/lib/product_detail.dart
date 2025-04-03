import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import 'ProductProviders/singleProvider.dart';
import 'ProductProviders/provider.dart';
import '../Types/Product_Type.dart';
import '../cart.dart';

class ProductDetailScreen extends StatefulWidget {
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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
            return Center(child: Text('Error: \${snapshot.error}'));
          } else if (snapshot.hasData) {
            products? product = snapshot.data?.firstWhere(
              (p) => p.sId == productId,
            );
            if (product == null) {
              return Center(child: Text('Product not found'));
            }

            List<String> mediaUrls = [];
            if (product.images != null && product.images!.isNotEmpty) {
              mediaUrls.addAll(
                product.images!
                    .map(
                      (img) => ProductService.getSanityImageUrl(
                        img.asset?.sRef ?? '',
                      ),
                    )
                    .where((url) => url.isNotEmpty)
                    .toList(),
              );
            }
            if (product.video != null && product.video!.asset?.sRef != null) {
              mediaUrls.add(
                ProductService.getSanityVideoUrl(product.video!.asset!.sRef!),
              );
            }

            return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                        mediaUrls.isNotEmpty
                            ? CarouselSlider(
                              options: CarouselOptions(
                                height: 150,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.8,
                              ),
                              items:
                                  mediaUrls.map((url) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return url.endsWith(".mp4") ||
                                                url.endsWith(".mov")
                                            ? VideoPlayerWidget(url: url)
                                            : Image.network(
                                              url,
                                              fit: BoxFit.contain,
                                              width: double.infinity,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    color: Colors.grey.shade200,
                                                    child: Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              },
                                            );
                                      },
                                    );
                                  }).toList(),
                            )
                            : Container(
                              height: 150,
                              width: double.infinity,
                              color: Colors.grey.shade200,
                              child: Icon(Icons.image_not_supported),
                            ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    product.title ?? 'No Title',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Price: Rs. " + product.price.toString() ?? 'No Price',
                    style: TextStyle(fontSize: 18, color: Colors.green),
                  ),
                  SizedBox(height: 20),
                  Text(
                    product.description ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        product != null
                            ? () async {
                              await saveProductToSharedPreferences(product);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShoppingCartPage(),
                                ),
                              );
                            }
                            : null,
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
    final String? existingJson = prefs.getString('cart_product');
    List<dynamic> productList =
        existingJson != null ? jsonDecode(existingJson) ?? [] : [];

    productList.add({
      'sId': product.sId,
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'image':
          product.images?.isNotEmpty == true
              ? product.images![0].asset!.sRef
              : '',
      'quantity': 1,
    });

    await prefs.setString('cart_product', jsonEncode(productList));
    print('Product saved to SharedPreferences as list of objects');
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) => setState(() => _controller.play()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
        : Center(child: CircularProgressIndicator());
  }
}
