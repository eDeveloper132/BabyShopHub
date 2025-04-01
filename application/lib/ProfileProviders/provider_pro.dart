import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Types/Profile_Type.dart';

class ProfileService with ChangeNotifier {
  Profiles? _profile;

  Profiles? get profile => _profile;
  Future<void> fetchProfile(String email) async {
    final url = Uri.parse(
      'https://baby-shop-hub-two.vercel.app/api/profiles?email=$email',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data is List && data.isNotEmpty) {
          _profile = Profiles.fromJson(
            data[0],
          ); // Assuming first item is needed
          notifyListeners();
        }
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (error) {
      throw Exception('Error fetching profile: $error');
    }
  }
}
