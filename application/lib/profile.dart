import 'package:application/ProfileProviders/provider_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:application/User/loginScreen.dart';
import 'ProductProviders/provider.dart'; // For ProductService

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userId');
    print('DEBUG: Retrieved userId from SharedPreferences: $email');

    if (email == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No email found. Please log in again.';
      });
      print('DEBUG: No email found in SharedPreferences.');
      return;
    }

    try {
      final profileService = Provider.of<ProfileService>(
        context,
        listen: false,
      );
      print('DEBUG: Fetching profile for email: $email');
      await profileService.fetchProfile(email);
      print('DEBUG: Profile fetched successfully: ${profileService.profile}');
      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load profile.';
      });
      print('DEBUG: Error fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('My Account')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text('My Account')),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    final profileService = Provider.of<ProfileService>(context);
    final profile = profileService.profile;

    if (profile == null) {
      print('DEBUG: Profile object is null.');
      return Scaffold(
        appBar: AppBar(title: Text('My Account')),
        body: Center(child: Text('No profile data available.')),
      );
    }

    String? sanityRef = profile.profileImage?.asset?.sRef;
    String profileImageUrl =
        (sanityRef != null && sanityRef.isNotEmpty)
            ? ProductService.getSanityImageUrl(sanityRef)
            : '';
    print('DEBUG: Profile Image URL: $profileImageUrl');

    return Scaffold(
      appBar: AppBar(title: Text('My Account'), backgroundColor: Colors.orange),
      body: ListView(
        children: [
          _buildProfileHeader(
            profile.username ?? 'No username',
            profile.email ?? 'No email',
            profileImageUrl,
          ),
          _buildAccountOptions(context),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(String username, String email, String imageUrl) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.orange,
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage:
                imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl) as ImageProvider
                    : AssetImage('../assets/banner1.jpg'),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(email, style: TextStyle(color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountOptions(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.settings, color: Colors.grey),
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.grey),
            title: Text('Help Center'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async => await _logout(context),
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
    await prefs.clear();
    print('DEBUG: User logged out, SharedPreferences cleared.');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }
}
