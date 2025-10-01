import 'package:flutter/material.dart';
import 'package:kampushare/screens/favorites_page/favorites_page.dart';
import '../screens/home_page/home_page.dart';
import '../screens/login_page/login_page.dart';
import '../screens/chat_menu_page/chat_menu_page.dart';
import '../screens/cart_page/cart_page.dart';
import '../screens/profile_menu_page/profile_menu_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String chatmenu = '/chatmenu';
  static const String cart = '/cart';
  static const String profilemenu = '/profilemenu';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginPage(),
    home: (context) => const HomePage(),
    favorites: (context) => const FavoritesPage(),
    chatmenu: (context) => const ChatMenuPage(),
    
  };
}