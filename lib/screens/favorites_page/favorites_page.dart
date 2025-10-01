import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import 'package:kampushare/screens/product_detail_page/product_detail_page.dart';
import '../../models/products.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class FavoritesPage extends StatefulWidget{

  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
{
  int _selectedItem = 1;

  void _onItemTapped(int index){
    setState(() {
      _selectedItem = index;
    });
    if(index == 0){
      Navigator.pushNamed(context, "/home");
    }
    else if(index == 3){
      Navigator.pushNamed(context, "/chatmenu");
    }
  }

  @override
  Widget build(BuildContext context){

    final favorites = context.watch<ProductsProvider>().products.where((p)=>p.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.orangeAccent,
        automaticallyImplyLeading: false, 
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF1F3F8) 
        ),
        child: favorites.isEmpty ? 
          const Center(child: Text("No Favorites Yet")) : 
          GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: favorites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3/4,
            ), 
            itemBuilder: (context, index){
              final product = favorites[index];
              return GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.image,
                              height: 160,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.pinkAccent,
                                ),
                                onPressed: () {
                                  setState(() {
                                    product.isFavorite = !product.isFavorite;
                                  });
                                }, 
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product.name, 
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '₺${product.price}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedItem, 
        onTap: _onItemTapped,
      ),
    );
  }
}