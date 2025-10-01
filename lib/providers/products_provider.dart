import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../models/products.dart';

class ProductsProvider extends ChangeNotifier{
  List<Product> _products = [];

  List<Product> get products => _products;
  List<Product> get favorites => _products.where((p) => p.isFavorite).toList();

  Future<void> loadProducts() async {
    final String response = await rootBundle.loadString('assets/products.json');
    final List<dynamic> data = json.decode(response);

    _products = data.map((item) => Product.fromJson(item)).toList();
    notifyListeners();
  }

  //Favorilere ekleme/çıkarma
  void toggleFavorite(int id){
    final index = _products.indexWhere((p) => p.id == id);
    if(index != -1){
      _products[index].isFavorite = !_products[index].isFavorite;
      notifyListeners();
    }
  }
}