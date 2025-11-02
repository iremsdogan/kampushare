import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String surname;
  final String username;
  final String email;
  final String passwordHash;
  final String phoneNumber;
  final String profileImage;
  final String university;
  final String department;
  final String? bioText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> favorites;
  final List<dynamic> cart;

  UserModel({
    required this.userId,
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    required this.passwordHash,
    required this.phoneNumber,
    required this.profileImage,
    required this.university,
    required this.department,
    required this.bioText,
    required this.createdAt,
    required this.updatedAt,
    required this.favorites,
    required this.cart,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      name: json['name'],
      surname: json['surname'],
      username: json['username'],
      email: json['email'],
      passwordHash: json['password_hash'],
      phoneNumber: json['phone_number'],
      profileImage: json['profile_image'],
      university: json['university'],
      department: json['department'],
      bioText: json['bio_text'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      favorites: json['favorites'] is List ? json['favorites'] : [],
      cart: json['cart'] is List ? json['cart'] : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'surname': surname,
      'username': username,
      'email': email,
      'password_hash': passwordHash,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
      'university': university,
      'department': department,
      'bio_text': bioText,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'favorites': favorites,
      'cart': cart,
    };
  }

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      userId: doc.id,
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      passwordHash: data['password_hash'] ?? '',
      phoneNumber: data['phone_number'] ?? '',
      profileImage: data['profile_image'] ?? '',
      university: data['university'] ?? '',
      department: data['department'] ?? '',
      bioText: data['bio_text'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      favorites: data['favorites'] is List ? List<dynamic>.from(data['favorites']) : [],
      cart: data['cart'] is List ? List<dynamic>.from(data['cart']) : [],
    );
  }
}
