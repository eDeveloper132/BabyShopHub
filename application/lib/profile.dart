import 'package:application/User/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          _buildProfileHeader(),
          _buildWalletSection(),
          _buildAccountOptions(context),
          _buildLogoutButton(context),
        ],
        
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.orange,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage('../assets/banner1.jpg'),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              Text(
                'john.doe@example.com',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWalletSection() {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_balance_wallet, color: Colors.orange),
            title: Text('Wallet Balance: \$100'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.local_offer, color: Colors.orange),
            title: Text('Coupons'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: Colors.orange),
            title: Text('My Orders'),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOptions(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey),
            title: Text('Settings'),
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.grey),
            title: Text('Help Center'),
          ),
        ],
      ),
    );
  }

Widget _buildLogoutButton(BuildContext context) {
  return Padding(
    padding: EdgeInsets.all(16.0),
    child: ElevatedButton(
      onPressed: () async {
        await _logout(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text('Logout', style: TextStyle(color: Colors.white)),
    ),
  );
}

Future<void> _logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // Clear stored session data

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => AuthScreen()), // Redirect to login screen
  );
}
}
