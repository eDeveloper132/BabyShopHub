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
      appBar: AppBar(
        title: Text('My Account'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navigate to the edit profile screen.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(profile: profile),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildProfileHeader(
            profile.username ?? 'No username',
            profile.email ?? 'No email',
            profileImageUrl,
          ),
          _buildProfileDetails(profile),
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

  Widget _buildProfileDetails(profile) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              Icons.person,
              'Username',
              profile.username ?? 'N/A',
            ),
            _buildDetailRow(Icons.email, 'Email', profile.email ?? 'N/A'),
            _buildDetailRow(
              Icons.cake,
              'Date of Birth',
              profile.dateOfBirth ?? 'N/A',
            ),
            _buildDetailRow(Icons.home, 'Address', profile.address ?? 'N/A'),
            _buildDetailRow(
              Icons.phone,
              'Phone Number',
              profile.phoneNumber ?? 'N/A',
            ),
            _buildDetailRow(
              Icons.local_post_office,
              'Postal Code',
              profile.postalCode ?? 'N/A',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 10),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(color: Colors.black54))),
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

/// This screen allows updating profile fields.
class EditProfilePage extends StatefulWidget {
  final dynamic profile;
  EditProfilePage({required this.profile});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _addressController;
  late TextEditingController _emailController;
  late TextEditingController _postalCodeController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _dateOfBirthController;
  // Add additional controllers if needed, e.g. profileImage

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing profile data.
    _usernameController = TextEditingController(text: widget.profile.username);
    _addressController = TextEditingController(text: widget.profile.address);
    _emailController = TextEditingController(text: widget.profile.email);
    _postalCodeController = TextEditingController(
      text: widget.profile.postalCode,
    );
    _phoneNumberController = TextEditingController(
      text: widget.profile.phoneNumber,
    );
    _dateOfBirthController = TextEditingController(
      text: widget.profile.dateOfBirth,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _postalCodeController.dispose();
    _phoneNumberController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState?.validate() != true) return;

    try {
      await Provider.of<ProfileService>(context, listen: false).updateProfile(
        id: widget.profile.sId ?? '', // Use sId from your Profiles class
        username: _usernameController.text,
        address: _addressController.text,
        email: _emailController.text,
        postalCode: _postalCodeController.text,
        phoneNumber: _phoneNumberController.text,
        dateOfBirth: _dateOfBirthController.text,
        // If you have a field for profileImage, pass it here.
      );
      Navigator.pop(context); // Return to the profile page.
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // You can add validators as needed.
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _postalCodeController,
                decoration: InputDecoration(labelText: 'Postal Code'),
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
              TextFormField(
                controller: _dateOfBirthController,
                decoration: InputDecoration(labelText: 'Date of Birth'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
