import 'package:flutter/material.dart';
import '../screens/my_favorites_page/my_favorites_page.dart';
import '../screens/other_favorites/other_favorites.dart';
import '../screens/add_product_page/add_product_page.dart';
import '../models/user_model.dart';
import '../screens/followers_page/followers_page.dart';
import '../screens/following_page/following_page.dart';
import '../screens/home_page/home_page.dart';
import '../screens/login_page/login_page.dart';
import '../screens/chat_menu_page/chat_menu_page.dart';
import '../screens/cart_page/cart_page.dart';
import '../screens/profile_menu_page/profile_menu_page.dart';
import '../screens/edit_profile_page/edit_profile.dart';
import '../screens/notifications_page/notifications_page.dart';
import '../screens/change_password/change_password.dart';
import '../screens/mypage_page/mypage_page.dart';
import '../screens/profile_setting_page/profile_settings_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String myfavorites = '/myfavorites';
  static const String chatmenu = '/chatmenu';
  static const String addproduct = '/addproduct';
  static const String cart = '/cart';
  static const String profilemenu = '/profilemenu';
  static const String mypage = '/mypage';
  static const String followers = '/followers';
  static const String following = '/following';
  static const String otherfavorites = '/otherfavorites';
  static const String profilesettings = '/profilesettings';
  static const String editprofile = '/editprofile';
  static const String notifications = '/notifications';
  static const String changepassword = '/changepassword';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
         final user = settings.arguments as UserModel;
        return MaterialPageRoute(builder: (_) => HomePage(user: user));
      case myfavorites:
        return MaterialPageRoute(builder: (_) => const MyFavoritesPage(), settings: settings);
      case addproduct:
        return MaterialPageRoute(builder: (_) => const AddProductPage());
      case chatmenu:
        return MaterialPageRoute(builder: (_) => const ChatMenuPage(), settings: settings);
      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage(), settings: settings);
      case profilemenu:
        return MaterialPageRoute(builder: (_) => const ProfileMenuPage(), settings: settings);
      case mypage:
        return MaterialPageRoute(builder: (_) => const MypagePage(), settings: settings);
      case followers:
        return MaterialPageRoute(builder: (_) => const FollowersPage(), settings: settings);
      case following:
        return MaterialPageRoute(builder: (_) => const FollowingPage(), settings: settings);
      case otherfavorites:
        return MaterialPageRoute(builder: (_) => const OtherFavoritesPage(), settings: settings);
      case profilesettings:
        return MaterialPageRoute(builder: (_) => const ProfileSettingsPage(), settings: settings);
      case editprofile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage(), settings: settings);
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case changepassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}