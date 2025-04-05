import 'package:application/ProductProviders/provider.dart'; // Import ProductService
import 'package:application/ProductProviders/singleProvider.dart';
import 'package:application/ProfileProviders/provider_pro.dart';
import 'package:application/product_detail.dart';
import 'package:application/profile.dart';
import 'package:provider/provider.dart';
import 'package:application/Types/Product_Type.dart';
import 'package:application/cart.dart';
import 'package:application/orders.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'User/loginScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  bool isLoggedIn = await checkUserSession();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SingleServiceProvider()),
        ChangeNotifierProvider(create: (context) => ProfileService()),
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

Future<bool> checkUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId') != null;
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyShopHub',
      theme: ThemeData(
        primaryColor: const Color(0xFFFFA7B3),
        scaffoldBackgroundColor: const Color(0xFFFCEFF1),
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomeScreen() : AuthScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCategory = 'Outfits'; // Initial category

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(
      'userId',
    ); // Make sure email is saved at login

    if (email != null) {
      final profileService = Provider.of<ProfileService>(
        context,
        listen: false,
      );
      await profileService.fetchProfile(email);
    } else {
      print("No email found in SharedPreferences.");
    }
  }

  final List<Map<String, String>> categories = [
    {'title': 'Outfits', 'image': '../assets/outfit.jpg'},
    {'title': 'Toys', 'image': '../assets/toyr.png'},
    {'title': 'Watches', 'image': '../assets/watch.jpg'},
    {'title': 'Innerwears', 'image': '../assets/Innerwear.jpg'},
  ];

  // Fetch products based on the selected category
  Future<List<Products>> _getProductsFuture() {
    switch (selectedCategory) {
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

  // New function to fetch slider data
  Future<List<Products>> _getSliderFuture() {
    return ProductService.fetchSlider();
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BabyShopHub'),
        backgroundColor: const Color(0xFFFFA7B3),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCartPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel slider using API response instead of local assets
            // Carousel slider using API response instead of local assets
            FutureBuilder<List<Products>>(
              future: _getSliderFuture(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SizedBox(
                    height: 180,
                    child: Center(child: Text('Error loading slider')),
                  );
                } else if (snapshot.hasData) {
                  final sliderProducts = snapshot.data!;
                  // Flatten all images from all slider documents into a single list
                  List<String> sliderImageUrls = [];
                  for (var slider in sliderProducts) {
                    if (slider.images != null && slider.images!.isNotEmpty) {
                      sliderImageUrls.addAll(
                        slider.images!
                            .map(
                              (img) => ProductService.getSanityImageUrl(
                                img.asset?.sRef ?? '',
                              ),
                            )
                            .where((url) => url.isNotEmpty)
                            .toList(),
                      );
                    }
                  }
                  if (sliderImageUrls.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 180,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 16 / 9,
                      ),
                      items:
                          sliderImageUrls.map((imageUrl) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),

            const SizedBox(height: 20),
            _sectionTitle('Categories'),
            const SizedBox(height: 10),
            _buildCategoryList(),
            const SizedBox(height: 20),
            _sectionTitle(selectedCategory), // Dynamic title
            const SizedBox(height: 10),
            FutureBuilder<List<Products>>(
              future: _getProductsFuture(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final products = snapshot.data!;
                  return _buildProducts(products, selectedCategory);
                } else {
                  return const Center(child: Text('No products available.'));
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFFFA7B3),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            (context as Element).reassemble();
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OrdersPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index]['title']!;
          return _categoryItem(
            context,
            category,
            categories[index]['image']!,
            selectedCategory == category, // Highlight selected category
            () {
              setState(() {
                selectedCategory = category; // Update selected category
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildProducts(List<Products> products, String category) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Provider.of<SingleServiceProvider>(
                context,
                listen: false,
              ).setSelectedProductId(product.sId ?? '', category);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductDetailScreen()),
              );
            },
            child: _productCard(
              product.title ?? 'No Title',
              ProductService.getSanityImageUrl(
                (product.images != null && product.images!.isNotEmpty)
                    ? product.images![0].asset!.sRef!
                    : '',
              ),
              'Rs. ${product.price?.toString() ?? 'N/A'}',
              category,
            ),
          );
        },
      ),
    );
  }

  Widget _categoryItem(
    BuildContext context,
    String title,
    String imagePath,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
              child:
                  isSelected
                      ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                      )
                      : null,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _productCard(
    String title,
    String imagePath,
    String price,
    String category,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child: Image.network(
                imagePath,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 100,
                      width: 150,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.error, color: Colors.red),
                    ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 100,
                    width: 150,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category: $category',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFFFFA7B3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
