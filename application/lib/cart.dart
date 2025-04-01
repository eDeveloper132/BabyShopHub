import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  // Load the cart items from SharedPreferences.
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
        // If only one product is stored as a Map, convert it into a List.
        setState(() {
          cartItems = [
            Map<String, dynamic>.from(decoded)
              ..putIfAbsent('quantity', () => 1),
          ];
        });
      }
    }
  }

  // Save the current list of cart items back into SharedPreferences.
  Future<void> _saveCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonStr = jsonEncode(cartItems);
    await prefs.setString('cart_product', jsonStr);
  }

  // Calculate the total price based on (unitPrice * quantity) for each item.
  double _calculateTotal() {
    return cartItems.fold(0.0, (sum, item) {
      double unitPrice = (item['price'] as num).toDouble();
      int quantity = item['quantity'] as int;
      return sum + (unitPrice * quantity);
    });
  }

  // Increase the quantity for the item at [index] and update storage.
  void _incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity'] = (cartItems[index]['quantity'] as int) + 1;
    });
    _saveCartItems();
  }

  // Decrease the quantity for the item at [index] (not going below 1) and update storage.
  void _decrementQuantity(int index) {
    int currentQty = cartItems[index]['quantity'] as int;
    if (currentQty > 1) {
      setState(() {
        cartItems[index]['quantity'] = currentQty - 1;
      });
      _saveCartItems();
    }
  }

  // Remove an item at [index] and update storage.
  void _removeItem(int index) async {
    setState(() {
      cartItems.removeAt(index);
    });
    await _saveCartItems();
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

  // Build each cart item with image, title, computed total, quantity controls and a delete button.
  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    int quantity = item['quantity'] as int;
    double unitPrice = (item['price'] as num).toDouble();
    double itemTotal = unitPrice * quantity;

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            item['image'],
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
          onPressed: () {
            _removeItem(index);
          },
        ),
      ),
    );
  }

  // Build the bottom bar that shows the total and a checkout button.
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
            onPressed: () {
              // Implement checkout logic if needed.
            },
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
