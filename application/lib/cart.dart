import 'package:application/ProductProviders/provider.dart';
import 'package:application/ProfileProviders/provider_pro.dart';
import 'package:application/Types/Profile_Type.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'ProfileProviders/provider_pro.dart'; // Adjust path

class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  // Load cart items from SharedPreferences
  Future<void> _loadCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartProductJson = prefs.getString('cart_product');
    if (cartProductJson != null) {
      var decoded = jsonDecode(cartProductJson);
      if (decoded is List) {
        setState(() {
          cartItems =
              decoded.map<Map<String, dynamic>>((prod) {
                final product = Map<String, dynamic>.from(prod);
                if (product['quantity'] == null) {
                  product['quantity'] = 1;
                }
                return product;
              }).toList();
        });
      } else if (decoded is Map) {
        setState(() {
          cartItems = [
            Map<String, dynamic>.from(decoded)
              ..putIfAbsent('quantity', () => 1),
          ];
        });
      }
    }
  }

  // Save cart items to SharedPreferences
  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonStr = jsonEncode(cartItems);
    await prefs.setString('cart_product', jsonStr);
  }

  // Calculate total price
  double _calculateTotal() {
    return cartItems.fold(0.0, (sum, item) {
      double unitPrice = (item['price'] as num).toDouble();
      int quantity = item['quantity'] as int;
      return sum + (unitPrice * quantity);
    });
  }

  // Increment item quantity
  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity'] = (cartItems[index]['quantity'] as int) + 1;
    });
    _saveCartItems();
  }

  // Decrement item quantity
  void _decrementQuantity(int index) {
    int currentQty = cartItems[index]['quantity'] as int;
    if (currentQty > 1) {
      setState(() {
        cartItems[index]['quantity'] = currentQty - 1;
      });
      _saveCartItems();
    }
  }

  // Remove item from cart
  void _removeItem(int index) async {
    setState(() {
      cartItems.removeAt(index);
    });
    await _saveCartItems();
  }

  // Checkout process with payment simulation
  Future<void> _checkout() async {
    // Step 1: Validate cart
    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Your cart is empty')));
      return;
    }

    // Step 2: Show payment confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Confirm Payment'),
            content: Text(
              'Proceed with payment of Rs. ${_calculateTotal().toStringAsFixed(2)}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Confirm'),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    // Step 3: Simulate payment processing
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Processing payment...')));
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    // Step 4: Get user email
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('userId');
    if (email == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('User not logged in')));
      return;
    }

    // Step 5: Fetch user profile
    final profileService = Provider.of<ProfileService>(context, listen: false);
    Profiles? profile;
    try {
      profile = await profileService.fetchProfile(email);
      if (profile == null) throw Exception('Profile not found');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load profile: $e')));
      return;
    }

    // Step 6: Create new order
    final newOrder = PastOrders(
      orderId: DateTime.now().millisecondsSinceEpoch.toString(),
      orderDate: DateTime.now().toIso8601String(),
      totalAmount: _calculateTotal().toInt(),
      status: 'completed',
    );

    // Step 7: Update pastOrders
    final updatedPastOrders =
        profile.pastOrders != null
            ? [...profile.pastOrders!, newOrder]
            : [newOrder];

    // Step 8: Update profile with new order
    try {
      await profileService.updateProfile(profile.sId!, {
        'pastOrders': updatedPastOrders.map((order) => order.toJson()).toList(),
      });

      // Step 9: Clear cart
      setState(() {
        cartItems.clear();
      });
      await _saveCartItems();

      // Step 10: Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Order placed successfully')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.orange,
      ),
      body:
          cartItems.isEmpty
              ? Center(child: Text("Cart is empty"))
              : ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return _buildCartItem(cartItems[index], index);
                },
              ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    int quantity = item['quantity'] as int;
    double unitPrice = (item['price'] as num).toDouble();
    double itemTotal = unitPrice * quantity;
    String getImageRef(Map<String, dynamic> item) {
      if (item['image'] != null) {
        return item['image'];
      }
      if (item['images'] != null && item['images'].isNotEmpty) {
        return item['images'][0]['asset']['sRef'];
      }
      return '';
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            ProductService.getSanityImageUrl(getImageRef(item)),
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item['title'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rs. ${itemTotal.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed:
                        quantity == 1 ? null : () => _decrementQuantity(index),
                  ),
                  Text(
                    quantity.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _incrementQuantity(index),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeItem(index),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 16)),
              Text(
                "Rs. ${_calculateTotal().toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _checkout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Checkout',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
