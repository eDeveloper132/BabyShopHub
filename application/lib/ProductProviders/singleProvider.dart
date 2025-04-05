import 'package:flutter/material.dart';

class SingleServiceProvider extends ChangeNotifier {
  String? _selectedProductId;
  String? _selectedCategory;

  String? get selectedProductId => _selectedProductId;
  String? get selectedCategory => _selectedCategory;

  void setSelectedProductId(String id, String category) {
    _selectedProductId = id;
    _selectedCategory = category;
    notifyListeners();
  }
}
