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

    setState(() => _selectedItem = index);
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0.4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Profilim",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.teal),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profilesettings);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileCard(user),
            _sectionTitle("Hesabım"),
            _menuItem(
              icon: Icons.storefront_outlined,
              title: "Benim Sayfam",
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.mypage,
                arguments: user,
              ),
            ),
            _menuItem(
              icon: Icons.favorite_border,
              title: "Favorilerim",
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.myfavorites,
                arguments: user,
              ),
            ),
            _menuItem(
              icon: Icons.shopping_cart_outlined,
              title: "Sepetim",
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.cart,
                arguments: user,
              ),
            ),
            _menuItem(
              icon: Icons.message_outlined,
              title: "Mesajlarım",
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutes.chatmenu,
                arguments: user,
              ),
            ),
            _sectionTitle("Ayarlar"),
            _menuItem(
              icon: Icons.verified_user_outlined,
              title: "Satıcı Doğrulama",
              onTap: () {},
            ),
            _menuItem(
              icon: Icons.notifications_outlined,
              title: "Bildirim Ayarları",
              onTap: () {},
            ),
            _menuItem(
              icon: Icons.settings_outlined,
              title: "Hesap Ayarları",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.profilesettings);
              },
            ),
            _sectionTitle("Diğer"),
            _menuItem(
              icon: Icons.help_outline,
              title: "Yardım & Destek",
              onTap: () {},
            ),
            _menuItem(
              icon: Icons.feedback_outlined,
              title: "Geri Bildirim Gönder",
              onTap: () {},
            ),
            _menuItem(
              icon: Icons.work_outline,
              title: "Biz Kimiz?",
              onTap: () {},
            ),
            const SizedBox(height: 24),
            _menuItem(
              icon: Icons.logout,
              title: "Çıkış Yap",
              color: Colors.redAccent,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedItem,
        onTap: _onItemTapped,
      ),
    );
  }
  Widget _profileCard(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundImage: NetworkImage(user.profileImage),
          ),
          const SizedBox(height: 12),
          Text(
            "@${user.username}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(
              color: Colors.black45,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 34, 8, 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black45,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.9,
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.teal,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: color == Colors.redAccent
                      ? Colors.redAccent
                      : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
