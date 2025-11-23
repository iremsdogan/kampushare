import 'package:flutter/material.dart';
import 'package:kampushare/routes/routes.dart';
import '../../models/user_model.dart';

class ProfileSettingsPage extends StatefulWidget{
  const ProfileSettingsPage ({super.key});

  @override
  State<ProfileSettingsPage> createState() => _ProfileMenuPageState();
}

class _ProfileMenuPageState extends State<ProfileSettingsPage>{

  bool callNotifications = false;
  bool twoFactorAuth = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xFFF1F3F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profil Ayarları",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                  radius: 55,
                  backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5",
                  ),
                ),
                  Positioned(
                    bottom: 0,
                    right: 2,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            _buildInput(nameController, "Ad"),
            const SizedBox(height: 15),
            _buildInput(surnameController, "Soyad"),
            const SizedBox(height: 15),
            _buildInput(usernameController, "Kullanıcı Adı"),
            const SizedBox(height: 15),
            _buildInput(phoneNumberController, "Telefon Numarası"),
            const SizedBox(height: 15),
            _buildMenuItem(
              icon: Icons.password,
              title: "Şifremi Değiştir",
              onTap: () {
                Navigator.pushNamed(
                  context, 
                  AppRoutes.changepassword,
                );
              },
            ),
            _buildSwitchRow(
              "Kampanyalarla ilgili çağrı al",
              callNotifications,
              (v) => setState(() => callNotifications = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "2 Adımlı Doğrulama",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: twoFactorAuth,
                  onChanged: (v) => setState(() => twoFactorAuth = v),
                  activeColor: Colors.teal,
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              "İki adımlı doğrulamayı etkinleştirdiğinizde şifrenize ek olarak "
              "kayıtlı cep telefonunuza gelen doğrulama kodu ile giriş yaparsınız.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 80),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){}, 
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Kaydet",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        )
      )
    );
  }

  Widget _buildInput(TextEditingController controller, String hint){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 15, color: Colors.black54),
          border: InputBorder.none,
        ),
      )
    );
  }

  Widget _buildSwitchRow(String title, bool value, Function(bool) onChange) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(color: Colors.black54 ,fontSize: 18, fontWeight: FontWeight.w500)),
        Switch(
          value: value,
          onChanged: onChange,
          activeColor: Colors.teal,
        ),
      ],
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: ListTile(
        leading: Icon(icon, color: textColor ?? Colors.black54),
        title: Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}