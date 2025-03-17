import 'package:application/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _submitAuthForm() async {
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (!_isLogin && (fullName.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty)) {
      _showError('Please fill all fields');
      return;
    }
    if (!_isLogin && password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }
    if (_isLogin && (email.isEmpty || password.isEmpty)) {
      _showError('Please fill all fields');
      return;
    }

    try {
      if (_isLogin) {
        var uuid = Uuid();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', email);
        await prefs.setString('token', uuid.v4());

        await _auth.signInWithEmailAndPassword(email: email, password: password);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        _showSuccess('Login Successful!');
      } else {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        User? user = userCredential.user;
        if (user != null) {
          await user.updateDisplayName(fullName);
          await user.reload();

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          _showSuccess('Registration Successful!');
        }
      }
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? 'Authentication error');
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message')),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pinkColor = const Color(0xFFFF80AB);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isLogin ? 'Welcome to BabyShopHub' : 'Create an Account',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              if (!_isLogin)
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: pinkColor),
                  ),
                ),
              if (!_isLogin) const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email, color: pinkColor),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock, color: pinkColor),
                ),
              ),
              const SizedBox(height: 10),
              if (!_isLogin)
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: pinkColor),
                  ),
                ),
              if (!_isLogin) const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitAuthForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: pinkColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  _isLogin ? 'Login' : 'Register',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: _toggleAuthMode,
                child: Text(
                  _isLogin ? 'Create an Account' : 'Already have an account? Login',
                  style: TextStyle(color: pinkColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
