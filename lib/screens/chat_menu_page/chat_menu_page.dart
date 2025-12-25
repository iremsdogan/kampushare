import 'package:flutter/material.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../models/user_model.dart';
import '../../routes/routes.dart';

class ChatMenuPage extends StatefulWidget{
  const ChatMenuPage({super.key});

  @override
  State<ChatMenuPage> createState() => _ChatMenuPageState();
}

class _ChatMenuPageState extends State<ChatMenuPage>{

  int _selectedItem = 3;

  void _onItemTapped(int index){
    setState(() {
      _selectedItem = index;
    });
    final user = ModalRoute.of(context)!.settings.arguments as UserModel?;
    if(index == 0){
      Navigator.pushNamed(context, AppRoutes.home, arguments: user);
    }
    else if(index == 1){
      Navigator.pushNamed(context, AppRoutes.myfavorites, arguments: user);
    }
    else if(index == 2){
      Navigator.pushNamed(context, AppRoutes.addproduct);
    }
    else if(index == 4){
      Navigator.pushNamed(context, AppRoutes.profilemenu, arguments: user);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0.4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Mesajlarım",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),

      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text(
                "Henüz mesajınız yok",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Satıcıyla iletişime geçmek için bir ürün seçin",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedItem, 
        onTap: _onItemTapped,
      ),
    );
  }
}