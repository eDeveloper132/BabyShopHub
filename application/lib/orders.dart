import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Types/Profile_Type.dart';
import 'ProfileProviders/provider_pro.dart';

class OrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access ProfileService to retrieve the profile data
    final profileService = Provider.of<ProfileService>(context);
    // Use an empty list if there are no past orders
    final pastOrders = profileService.profile?.pastOrders ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('My Orders'), backgroundColor: Colors.orange),
      body:
          pastOrders.isEmpty
              ? Center(child: Text('No past orders'))
              : ListView.builder(
                itemCount: pastOrders.length,
                itemBuilder: (context, index) {
                  final order = pastOrders[index];
                  return _buildOrderItem(order);
                },
              ),
    );
  }

  Widget _buildOrderItem(PastOrders order) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${order.orderId ?? ''}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            // Example row for product image and details.
            // Replace with actual product details if available.
            Row(
              children: [
                Image(
                  image: AssetImage('assets/banner1.jpg'),
                  width: 80,
                  height: 80,
                ),
                SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Name', // Update if product name exists in your order model.
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Qty: 1', // Update accordingly if quantity info is available.
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '\$${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status: ${order.status ?? ''}',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add navigation to a detailed order view if needed
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(
                    'View Details',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
