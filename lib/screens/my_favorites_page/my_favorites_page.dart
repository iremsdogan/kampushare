import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../widgets/product_grid.dart';
import '../../widgets/product_filter_bar.dart';
import '../../routes/routes.dart';

class MyFavoritesPage extends StatefulWidget{
  const MyFavoritesPage({super.key});

  @override
  State<MyFavoritesPage> createState() => _MyFavoritesPageState();
}

class _MyFavoritesPageState extends State<MyFavoritesPage>
{
  int _selectedItem = 1;
  bool hideSold = false;

  void _onItemTapped(int index){
    setState(() {
      _selectedItem = index;
    });
    final user = ModalRoute.of(context)!.settings.arguments as UserModel?;
    if(index == 0){
      Navigator.pushNamed(context, AppRoutes.home, arguments: user);
    } else if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.addproduct);
    }
    else if(index == 3){
      Navigator.pushNamed(context, AppRoutes.chatmenu, arguments: user);
    } else if (index == 4) {
      Navigator.pushNamed(context, AppRoutes.profilemenu, arguments: user);
    }
  }

  @override
  Widget build(BuildContext context){

    final user = ModalRoute.of(context)!.settings.arguments as UserModel?;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Kullanıcı bilgisi bulunamadı.")));
    }
    final favorites = context.watch<ProductsProvider>().products.where((p)=>p.isFavorite).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const  Color(0xFFFFFFFF),
        elevation: 0.4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Favorilerim",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          ProductFilterBar(
            hideSold: hideSold,
            onSort: () {
              print("Sırala tıklandı");
            },
            onFilter: () {
              print("Filtrele tıklandı");
            },
            onToggleHideSold: () {
              setState(() {
                hideSold = !hideSold;
              });
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5) 
              ),
              child: favorites.isEmpty ? 
                  const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border_outlined,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Henüz favori ürün eklemediniz', 
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Beğendiğiniz ürünleri favorilerinize ekleyin', 
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                  ) 
                : 
                ProductGrid(
                  products: favorites,
                  padding: const EdgeInsets.all(12),
                ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedItem, 
        onTap: _onItemTapped,
      ),
    );
  }
}