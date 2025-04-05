import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'ProductProviders/singleProvider.dart';
import 'ProductProviders/provider.dart';
import '../Types/Product_Type.dart';
import '../cart.dart';
import 'package:chewie/chewie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  ProductDetailScreenState createState() => ProductDetailScreenState();
}

class ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFullScreen = false;
  String? _videoUrl;

  Future<List<Products>> _getProductsFuture(String? category) {
    switch (category) {
      case 'Outfits':
        return ProductService.fetchOutfits();
      case 'Toys':
        return ProductService.fetchToys();
      case 'Watches':
        return ProductService.fetchWatches();
      case 'Innerwears':
        return ProductService.fetchInnerwear();
      default:
        return Future.error('Invalid category');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SingleServiceProvider>(context);
    final productId = provider.selectedProductId;
    final category = provider.selectedCategory;

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.keyF) {
          setState(() {
            _isFullScreen = !_isFullScreen;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Product Details")),
        body: FutureBuilder<List<Products>>(
          future: _getProductsFuture(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              Products? product = snapshot.data?.firstWhere(
                (p) => p.sId == productId,
                orElse:
                    () => Products(), // Return an empty product if not found
              );
              if (product?.sId == null) {
                return const Center(child: Text('Product not found'));
              }

              List<String> imageUrls =
                  product!.images != null
                      ? product.images!
                          .map(
                            (img) => ProductService.getSanityImageUrl(
                              img.asset?.sRef ?? '',
                            ),
                          )
                          .where((url) => url.isNotEmpty)
                          .toList()
                      : [];

              _videoUrl =
                  product.video != null && product.video!.asset?.sRef != null
                      ? ProductService.getSanityVideoUrl(
                        product.video!.asset!.sRef!,
                      )
                      : null;

              if (kDebugMode && _videoUrl != null) {
                print('Generated video URL: $_videoUrl');
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrls.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.8,
                            ),
                            items:
                                imageUrls.map((url) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Image.network(
                                        url,
                                        fit: BoxFit.contain,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  color: Colors.grey.shade200,
                                                  child: const Icon(
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
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                    },
                                  );
                                }).toList(),
                          ),
                        )
                      else
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported),
                        ),
                      const SizedBox(height: 10),
                      if (_videoUrl != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Product Video',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.share,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _shareVideo(_videoUrl!),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            _isFullScreen
                                ? SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: ControlledVideoPlayer(url: _videoUrl!),
                                )
                                : Container(
                                  height: 200,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: ControlledVideoPlayer(
                                      url: _videoUrl!,
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      const SizedBox(height: 10),
                      Text(
                        product.title ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Price: Rs. ${product.price?.toString() ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        product.description ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          await saveProductToSharedPreferences(product);
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShoppingCartPage(),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                        ),
                        child: const Text(
                          "Add to Cart & Checkout",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No product details available.'));
            }
          },
        ),
      ),
    );
  }

  Future<void> saveProductToSharedPreferences(Products product) async {
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
    if (kDebugMode) {
      print('Product saved to SharedPreferences as list of objects');
    }
  }

  void _shareVideo(String url) async {
    try {
      await Share.share('Check out this product video: $url');
    } catch (e) {
      if (kDebugMode) {
        print('Error sharing: $e');
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to share: $e')));
    }
  }
}

// ControlledVideoPlayer remains unchanged
class ControlledVideoPlayer extends StatefulWidget {
  final String url;

  const ControlledVideoPlayer({super.key, required this.url});

  @override
  ControlledVideoPlayerState createState() => ControlledVideoPlayerState();
}

class ControlledVideoPlayerState extends State<ControlledVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  double? _aspectRatio;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(widget.url),
      )
      ..initialize()
          .then((_) {
            if (mounted) {
              setState(() {
                _aspectRatio = _videoPlayerController.value.aspectRatio;
              });
            }
          })
          .catchError((error) {
            if (kDebugMode) {
              print('Error initializing video: $error');
            }
          });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      allowFullScreen: false,
      allowMuting: true,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _aspectRatio != null
        ? Chewie(controller: _chewieController)
        : const Center(child: CircularProgressIndicator());
  }
}
