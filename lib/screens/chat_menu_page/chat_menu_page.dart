import 'package:flutter/material.dart';
import '../../models/products.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

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
    if(index == 0){
      Navigator.pushNamed(context, "/home");
    }
    else if(index == 1){
      Navigator.pushNamed(context, "/favorites");
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedItem, 
        onTap: _onItemTapped,
      ),
    );
  }
}