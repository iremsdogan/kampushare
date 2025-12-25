import 'package:flutter/material.dart';
import 'package:kampushare/routes/routes.dart';

class ProfileSettingsPage extends StatefulWidget{
  const ProfileSettingsPage({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.black
          ),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
        centerTitle: true,
        title: const Text(
          'Ayarlar', 
          style: TextStyle(
            color: Colors.black, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: const BoxDecoration(
          border:Border(
              bottom: BorderSide(
                color: Colors.black26,
                width: 0.7,
              )
          )
        ),
        child: Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              _buildMenuItem(
                icon: Icons.person_outline,
                title: "Profili Düzenle",
                onTap: () {
                  Navigator.pushNamed(
                    context, 
                    AppRoutes.editprofile);
                },
              ),
              _buildMenuItem(
                icon: Icons.password,
                title: "Şifremi Değiştir",
                onTap: () {
                  Navigator.pushNamed(
                    context, 
                    AppRoutes.changepassword);
                },
              ),
              _buildMenuItem(
                icon: Icons.verified_user_outlined,
                title: "Satıcı Doğrulama",
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.beach_access_outlined,
                title: "Tatil Modu",
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.close_outlined,
                title: "Hesabımı Kapat",
                onTap: () {},
              ),
            ],
          ),
        ),
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
      color: Color(0xFFFFFFFF),
      surfaceTintColor: Color(0xFFFFFFFF),
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
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal,),
        onTap: onTap,
      ),
    );
  }
}