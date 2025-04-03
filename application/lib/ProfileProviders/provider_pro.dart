import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Types/Profile_Type.dart';

class ProfileService with ChangeNotifier {
  Profiles? _profile;

  Profiles? get profile => _profile;

  Future<Profiles?> fetchProfile(String email) async {
    final url = Uri.parse(
      'https://baby-shop-hub-two.vercel.app/api/profiles?email=$email',
    );
    try {
      print('Fetching profile for email: $email');
      final response = await http.get(url);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data');
        if (data != null) {
          if (data is List && data.isNotEmpty) {
            _profile = Profiles.fromJson(data[0] as Map<String, dynamic>);
          } else if (data is Map) {
            _profile = Profiles.fromJson(data.cast<String, dynamic>());
          }
          print('Profile fetched successfully: ${_profile?.toJson()}');
          notifyListeners();
          return _profile;
        } else {
          print('No data received from API');
        }
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching profile: $error');
      throw Exception('Error fetching profile: $error');
    }
    return null;
  }

  // skZjFo4yR7eAYY4UEIkJW1Dv0ldN2MtxXrO2x6Le2rwlILBz3j4mPsul5M8pZ2z85CLNibErOOKTq3kfof0ZNYanXYINw9O4Ep7alebTitTSjxTioHa4qRtUbG8m9aEURCHf2dzmIUr17heQnrU7xP66Pn6Rw7uXrc3AQGXhf12TX7i66kJj
  Future<void> updateProfile(String id, Map<String, dynamic> updates) async {
    final url = Uri.parse('https://baby-shop-hub-two.vercel.app/api/profiles');
    final requestBody = {"id": id, ...updates};
    print('Updating profile with ID: $id');
    print('Request body: ${json.encode(requestBody)}');

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},

        body: json.encode(requestBody),
      );
      print('Response status code: ${response}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data');
        if (data != null) {
          _profile = Profiles.fromJson(data.cast<String, dynamic>());
          print('Profile updated successfully: ${_profile?.toJson()}');
          notifyListeners();
        } else {
          print('No data received from API after update');
        }
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating profile: $error');
      throw Exception('Error updating profile: $error');
    }
  }
}
