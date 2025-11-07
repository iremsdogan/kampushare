import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductsProvider extends ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Product> _products = [];
  String? _userId;
  List<String> _favoriteProductIds = [];

  List<Product> get products => _products;
  List<Product> get favorites => _products.where((p) => p.isFavorite).toList();

  void setUserId(String? userId) {
    _userId = userId;
    if (userId == null) {
      _favoriteProductIds = [];
    }
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      if (_userId != null) {
        final userDoc = await _firestore.collection('users').doc(_userId).get();
        if (userDoc.exists && userDoc.data()!.containsKey('favorites')) {
          _favoriteProductIds = List<String>.from(userDoc.data()!['favorites']);
        }
      }

      final snapshot = await _firestore.collection('products').get();

      _products = snapshot.docs.map((doc) {
        final data = doc.data();
        return Product.fromJson({
          ...data,
          'product_id': doc.id, 
          'isFavorite': _favoriteProductIds.contains(doc.id),
        });
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Firestore’dan ürünler yüklenirken hata: $e');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final productData = product.toFirestore();
      productData['user_id'] = _userId;
      await _firestore.collection('products').add(productData);
      await loadProducts();
    } catch (e) {
      print('Ürün eklenirken hata: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _firestore
          .collection('products')
          .doc(product.productId)
          .update(product.toJson());
      await loadProducts();
    } catch (e) {
      print('Ürün güncellenirken hata: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      _products.removeWhere((p) => p.productId == productId);
      notifyListeners();
    } catch (e) {
      print('Ürün silinirken hata: $e');
    }
  }

  Future<void> toggleFavorite(String productId) async {
    try {
      if (_userId == null) return;

      final index = _products.indexWhere((p) => p.productId == productId);
      if (index == -1) return;

      final product = _products[index];
      product.isFavorite = !product.isFavorite;

      if (product.isFavorite) {
        _favoriteProductIds.add(productId);
        await _firestore.collection('users').doc(_userId).update({
          'favorites': FieldValue.arrayUnion([productId])
        });
      } else {
        _favoriteProductIds.remove(productId);
        await _firestore.collection('users').doc(_userId).update({
          'favorites': FieldValue.arrayRemove([productId])
        });
      }

      notifyListeners();
    } catch (e) {
      print('Favori güncellenirken hata: $e');
    }
  }
}