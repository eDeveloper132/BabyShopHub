import 'package:flutter/material.dart';

class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: 3, // Example: 3 items in the cart
        itemBuilder: (context, index) {
          return _buildCartItem();
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildCartItem() {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Image.asset('../assets/banner1.jpg', width: 60, height: 60),
        title: Text('Product Name'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$20.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
            Row(
              children: [
                IconButton(icon: Icon(Icons.remove), onPressed: () {}),
                Text('1', style: TextStyle(fontSize: 16)),
                IconButton(icon: Icon(Icons.add), onPressed: () {}),
              ],
            )
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total:', style: TextStyle(fontSize: 16)),
              Text('\$60.00', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text('Checkout', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
