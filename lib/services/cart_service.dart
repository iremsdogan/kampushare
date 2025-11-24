import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() {
    return _instance;
  }
  CartService._internal();

  final List<Product> _items = [];
  final Map<String, bool> _selectedItems = {};

  List<Product> get items => _items;

  double get totalPrice {
    double total = 0.0;
    for (var item in _items) {
      if (_selectedItems[item.productId] == true) {
        total += item.price;
      }
    }
    return total;
  }

  void add(Product product) {
    if (!_items.any((item) => item.productId == product.productId)) {
      _items.add(product);
      _selectedItems[product.productId] = true;
      notifyListeners();
    }
  }

  void remove(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    _selectedItems.remove(productId);
    notifyListeners();
  }

  void toggleSelection(String productId) {
    if (_selectedItems.containsKey(productId)) {
      _selectedItems[productId] = !_selectedItems[productId]!;
      notifyListeners();
    }
  }

  bool isSelected(String productId) {
    return _selectedItems[productId] ?? false;
  }

  bool get areAllSelected {
    if (_items.isEmpty) {
      return false;
    }
    return _items.every((item) => _selectedItems[item.productId] == true);
  }

  void toggleAllSelection() {
    final bool selectAll = !areAllSelected;
    for (var item in _items) {
      _selectedItems[item.productId] = selectAll;
    }
    notifyListeners();
  }
}