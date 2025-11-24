import 'package:flutter/material.dart';
import 'package:kampushare/routes/routes.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../models/user_model.dart';

class ProfileMenuPage extends StatefulWidget {
  const ProfileMenuPage({super.key});

  @override
  State<ProfileMenuPage> createState() => _ProfileMenuPageState();
}

class _ProfileMenuPageState extends State<ProfileMenuPage> {
  int _selectedItem = 4;

  void _onItemTapped(int index) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;

    if (index == 0) {
      Navigator.pushNamed(context, AppRoutes.home, arguments: user);
    } else if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.myfavorites, arguments: user);
    } else if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.addproduct);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.chatmenu, arguments: user);
    }

    setState(() {
      _selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.teal,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Center(
                child:
                  Text(
                    "Profilim",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F8),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.profileImage),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "@${user.username}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildMenuItem(
                    icon: Icons.storefront_outlined,
                    title: "Benim Sayfam",
                    onTap: () {
                      Navigator.pushNamed(
                        context, 
                        AppRoutes.mypage, 
                        arguments: user);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.verified_user_outlined,
                    title: "Satıcı Doğrulama",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.favorite_border,
                    title: "Favorilerim",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.myfavorites, arguments: user);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.message_outlined,
                    title: "Mesajlarım",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.chatmenu, arguments: user);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.shopping_cart_outlined,
                    title: "Sepetim",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.cart, arguments: user);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: "Ayarlar",
                    onTap: () {
                      Navigator.pushNamed(
                        context, 
                        AppRoutes.profilesettings);
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.archive_outlined,
                    title: "Kaydettiğim Aramalar",
                    onTap: () {
                      
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.search,
                    title: "Son Gezdiklerim",
                    onTap: () {
                      
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.edit_notifications_outlined,
                    title: "Bildirim Ayarları",
                    onTap: () {
                      
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.work_outline_sharp,
                    title: "Biz Kimiz?",
                    onTap: () {
                      
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: "Yardım & Destek",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.feedback_outlined,
                    title: "Geri Bildirim Gönder",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: "Çıkış Yap",
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context, 
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                    textColor: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedItem,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: textColor ?? Colors.black),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
        onTap: onTap,
      ),
    );
  }
}
