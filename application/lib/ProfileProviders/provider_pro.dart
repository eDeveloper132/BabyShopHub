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
        if (data != null) {
          if (data is List && data.isNotEmpty) {
            _profile = Profiles.fromJson(data[0] as Map<String, dynamic>);
          } else if (data is Map) {
            _profile = Profiles.fromJson(data.cast<String, dynamic>());
          }
          notifyListeners();
        }
      } else {
        throw Exception('Failed to load profile');
      }
    } catch (error) {
      throw Exception('Error fetching profile: $error');
    }
  }

  Future<void> updateProfile({
    required String id,
    String? username,
    String? address,
    String? email,
    String? postalCode,
    String? phoneNumber,
    String? dateOfBirth,
    String? profileImage,
  }) async {
    final url = Uri.parse(
      'https://baby-shop-hub-two.vercel.app/api/profiles',
    ); // ✅ Fixed URL

    final Map<String, dynamic> requestBody = {
      "id": id,
      if (username != null) "username": username,
      if (address != null) "address": address,
      if (email != null) "email": email,
      if (postalCode != null) "postalCode": postalCode,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      if (dateOfBirth != null) "dateOfBirth": dateOfBirth,
      if (profileImage != null) "profileImage": profileImage,
    };

    print('DEBUG: Sending PUT request to: $url');
    print('DEBUG: Request Body: ${json.encode(requestBody)}');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      print('DEBUG: Response Status: ${response.statusCode}');
      print('DEBUG: Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null) {
          _profile = Profiles.fromJson(data.cast<String, dynamic>());
          notifyListeners();
        }
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      print('DEBUG: Error updating profile: $error');
      throw Exception('Error updating profile: $error');
    }
  }
}
