import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String _collectionName = 'products';

  Future<void> addProduct(Product product) async{
    try{
      await _firestore.collection(_collectionName).doc(product.productId).set(product.toJson());

      print("Ürün başarıyla eklendi: ${product.title}");
    }catch(e){
      print("Ürün eklenemedi: $e");
      rethrow;
    }
  }

  Future<List<Product>> getAllProducts() async {
    try{
      final snapshot = await _firestore.collection(_collectionName).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product.fromJson(data);
      }).toList();
    } catch (e){
      print("Ürünler alınamadı: $e");
      rethrow;
    }
  }

  Future<Product?> getProductById(String id) async{
    try{
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if(doc.exists){
        return Product.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print("Ürün getirilemedi: $e");
      rethrow;
    }
  }

  Future<void>  updateProduct(Product product) async{
    try{
      await _firestore.collection(_collectionName).doc(product.productId).update(product.toJson());

      print("Ürün güncellendi: ${product.title}");
    } catch(e) {
      print("Ürün güncellenemedi: $e");
      rethrow;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection(_collectionName).doc(productId).delete();
      print("Ürün silindi: $productId");
    } catch (e) {
      print("Ürün silinemedi: $e");
      rethrow;
    }
  }

  Future<List<Product>> getProductsByCategory(String category_name) async{
    try{
      final snapshot = await _firestore.collection(_collectionName).where('category_name', isEqualTo: category_name).get();

      return snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
    } catch (e) {
      print("Kategoriye göre ürün alınamadı: $e");
      rethrow;
    }
  }
}