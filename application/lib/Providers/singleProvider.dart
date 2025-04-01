import 'package:flutter/material.dart';

class SingleServiceProvider with ChangeNotifier {
  String? _selectedProductId;

  String? get selectedProductId => _selectedProductId;

  void setSelectedProductId(String productId) {
    _selectedProductId = productId;
    notifyListeners();
  }
}
