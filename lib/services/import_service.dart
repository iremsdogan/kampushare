import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class ImportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> importJsonToFirestore() async {
    final String response =
        await rootBundle.loadString('assets/users_products.json');
    final data = json.decode(response);

    final users = data['Users'] as Map<String, dynamic>;
    final products = data['Products'] as Map<String, dynamic>;

    for (var entry in users.entries) {
      final userId = entry.key; 
      final userData = entry.value; 
      await _firestore.collection('users').doc(userId).set(userData);
    }

    for (var entry in products.entries) {
      final productId = entry.key; 
      final productData = entry.value;
      await _firestore.collection('products').doc(productId).set(productData);
    }

    print("JSON Firestore'a yüklendi!");
  }
}
