import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String productId;
  final String userId;
  final String title;
  final String coverImageUrl;
  final List<String> productImages;
  final int price;
  final String categoryId;
  final String categoryName;
  final int likesCount;
  final String? description;
  final String? condition;
  final String? size;
  final String? dimension;
  final bool isSold;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> questions;
  bool isFavorite;

  Product({
    required this.productId,
    required this.userId,
    required this.title,
    required this.coverImageUrl,
    required this.productImages,
    required this.price,
    required this.categoryId,
    required this.categoryName,
    required this.likesCount,
    required this.description,
    required this.condition,
    this.size,
    this.dimension,
    required this.isSold,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      coverImageUrl: json['cover_image_url'] ?? '',
      productImages: json['product_images'] is List 
          ? List<String>.from(json['product_images']) 
          : [],
      price: (json['price'] as num?)?.toInt() ?? 0,
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      description: json['description'],
      condition: json['condition'],
      size: json['size'],
      dimension: json['dimension'],
      isSold: json['is_sold'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
      questions: json['questions'] is List ? json['questions'] : [],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'user_id': userId,
      'title': title,
      'cover_image_url': coverImageUrl,
      'product_images': productImages,
      'price': price,
      'category_id': categoryId,
      'category_name': categoryName,
      'likes_count': likesCount,
      'description': description,
      'condition': condition,
      'size': size,
      'dimension': dimension,
      'is_sold': isSold,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'questions': questions,
    };
  }

  factory Product.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ){
    final data = doc.data()!;
    return Product(
      productId: doc.id,
      userId: data['user_id'] ?? '',
      title: data['title'] ?? '',
      coverImageUrl: data['cover_image_url'] ?? '',
      productImages: List<String>.from(data['product_images'] ?? []),
      price: (data['price'] as num?)?.toInt() ?? 0,
      categoryId: data['category_id'] ?? '',
      categoryName: data['category_name'] ?? '',
      likesCount: data['likes_count'] ?? 0,
      description: data['description'],
      condition: data['condition'],
      size: data['size'],
      dimension: data['dimension'],
      isSold: data['is_sold'] ?? false,
      createdAt: (data['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updated_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      questions: data['questions'] ?? [],
      isFavorite: data['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore(){
    return{
      'user_id': userId,
      'title': title,
      'cover_image_url': coverImageUrl,
      'product_images': productImages,
      'price': price,
      'category_id': categoryId,
      'category_name': categoryName,
      'likes_count': likesCount,
      'description': description,
      'condition': condition,
      'size': size,
      'dimension': dimension,
      'is_sold': isSold,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': Timestamp.fromDate(updatedAt),
      'questions': questions,
    };
  }
  
}
