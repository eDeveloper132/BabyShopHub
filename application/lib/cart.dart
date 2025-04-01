import 'package:flutter/material.dart';

// This widget represents the shopping cart page, displaying cart items and a total with a checkout option.
class ShoppingCartPage extends StatelessWidget {
  // Simulated list of cart items
  final List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Josh',
      'price': 20.00,
      'quantity': 1,
      'image': '../assets/Josh.jpg',
    },
    {
      'name': 'Masturbator',
      'price': 25.00,
      'quantity': 2,
      'image': '../assets/masturbator.jpg',
    },
    {
      'name': 'Vibrator',
      'price': 15.00,
      'quantity': 1,
      'image': '../assets/vibrator.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: cartItems.length, // Dynamic item count based on cart items
        itemBuilder: (context, index) {
          return _buildCartItem(cartItems[index]);
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Builds each cart item with image, name, price, quantity controls, and delete button
  Widget _buildCartItem(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(
            8.0,
          ), // Rounded corners for images
          child: Image.asset(
            item['image'],
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          item['name'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '\$${item['price'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
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
                    onPressed: () {
                      // TODO: Implement decrease quantity logic
                    },
                  ),
                  Text(
                    item['quantity'].toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // TODO: Implement increase quantity logic
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            // TODO: Implement delete item logic
          },
        ),
      ),
    );
  }

  // Builds the bottom bar with total price and checkout button
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Colors.grey, width: 0.5)),
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
                '\$${_calculateTotal().toStringAsFixed(2)}',
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
              // TODO: Implement checkout logic
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

  // Calculates the total price based on cart items
  double _calculateTotal() {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + item['price'] * item['quantity'],
    );
  }
}
