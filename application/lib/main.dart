import 'package:application/Data/data.dart'; // Import ProductService
import 'package:application/Types/Classes.dart';
import 'package:application/cart.dart';
import 'package:application/orders.dart';
import 'package:application/profile.dart';
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

  runApp(MyApp(isLoggedIn: isLoggedIn));
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
        primaryColor: Color(0xFFFFA7B3),
        scaffoldBackgroundColor: Color(0xFFFCEFF1),
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? HomeScreen() : AuthScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<String> bannerImages = [
    '../assets/banner1.jpg',
    '../assets/banner2.jpg',
    '../assets/banner3.jpg',
  ];
  final List<Map<String, String>> categories = [
    {'title': 'Clothing', 'image': '../assets/clothing.jpg'},
    {'title': 'Toys', 'image': '../assets/toys.jpg'},
    {'title': 'Accessories', 'image': '../assets/accessories.jpg'},
  ];
  // final List<Map<String, String>> trendingProducts = [
  //   {
  //     'title': 'Baby Dress',
  //     'image': '../assets/dress.jpg',
  //     'price': 'Rs. 1200',
  //   },
  //   {'title': 'Soft Toy', 'image': '../assets/toy.jpg', 'price': 'Rs. 800'},
  //   {
  //     'title': 'Baby Shoes',
  //     'image': '../assets/shoes.jpg',
  //     'price': 'Rs. 1500',
  //   },
  // ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BabyShopHub'),
        backgroundColor: Color(0xFFFFA7B3),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushReplacement(
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
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
              ),
              items:
                  bannerImages.map((image) {
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }).toList(),
            ),
            SizedBox(height: 20),
            _sectionTitle('Categories'),
            SizedBox(height: 10),
            _buildCategoryList(),
            SizedBox(height: 20),
            _sectionTitle('Trending Products'),
            SizedBox(height: 10),
            // Use FutureBuilder to fetch and display trending products
            FutureBuilder<List<products>>(
              future: ProductService.fetchProducts(), // Fetch products here
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final trendingProducts = snapshot.data!;
                  return _buildTrendingProducts(
                    trendingProducts,
                  ); // Pass fetched products
                } else {
                  return Center(child: Text('No products available.'));
                }
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFA7B3),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                icon: Icon(Icons.track_changes, color: Colors.white),
                label: Text(
                  'Track Your Order',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  // Navigate to order tracking screen
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFFFFA7B3),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OrdersPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
        items: [
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
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          return _categoryItem(
            categories[index]['title']!,
            categories[index]['image']!,
          );
        },
      ),
    );
  }

  Widget _buildTrendingProducts(List<products> products) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _productCard(
            product.title ?? 'No Title',
            ProductService.getSanityImageUrl(product.images![0].asset!.sRef!),
            'Rs. ${product.price ?? 'N/A'}',
          );
        },
      ),
    );
  }

  Widget _categoryItem(String title, String imagePath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(imagePath)),
          SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _productCard(String title, String imagePath, String price) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.asset(
                imagePath,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(
                    price,
                    style: TextStyle(
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
