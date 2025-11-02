import 'package:flutter/material.dart';
import 'package:kampushare/routes/routes.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedItem = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedItem = index;
    });
    final user = ModalRoute.of(context)!.settings.arguments as UserModel?;
    if (index == 0) {
      Navigator.pushNamed(context, AppRoutes.home, arguments: user);
    } else if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.favorites, arguments: user);
    } else if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.addproduct); // AddProductPage argüman beklemiyor.
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.chatmenu, arguments: user);
    } else if (index == 4) {
      Navigator.pushNamed(context, AppRoutes.profilemenu, arguments: user);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    "Sepet",
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
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text(
                "Sepetiniz boş",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Henüz sepete eklenmiş bir ürün yok",
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
