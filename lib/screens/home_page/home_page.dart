import 'package:flutter/material.dart';
import 'package:kampushare/widgets/custom_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import 'package:kampushare/screens/favorites_page/favorites_page.dart';
import 'package:kampushare/screens/product_detail_page/product_detail_page.dart';
import '../../models/products.dart';
import '../chat_menu_page/chat_menu_page.dart';

class HomePage extends StatefulWidget{

  final String? username;
  const HomePage({super.key, this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  bool _isLoading = true;
  int _selectedItem = 0;

  @override
  void initState(){
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async{
    await context.read<ProductsProvider>().loadProducts();
    setState(() {
      _isLoading = false;
    });
  }

  void _onItemTapped(int item){
    if(item == 1) {
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => const FavoritesPage(),
        ),
      );
    }
    else if(item == 3){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChatMenuPage(),
        )
      );
    }
    else{
      setState(() {
        _selectedItem = item;
      });
    }
  }

  @override
  Widget build(BuildContext context){

    final products = context.watch<ProductsProvider>().products;

    return Scaffold(
      body: _isLoading ? const Center(child: CircularProgressIndicator(),) : 
      Container(
        decoration: const BoxDecoration(
            color: Color(0xFFF1F3F8),
        ),
        child: Column(
          children: [
            _buildSearchBar(),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20, top:10),
              child: const Text("Products", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,),),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: GridView.builder(
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 4, 
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _buildProductCard(product);
                  },
                ),
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

  Widget _buildSearchBar(){
    return Container(
        margin: const EdgeInsets.fromLTRB(10,50,10,10),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0,4),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Hello, ${widget.username ?? 'Guest'}', hintStyle: const TextStyle(fontWeight: FontWeight.bold),
            suffixIcon: const Icon(Icons.search),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
    );
  }

  Widget _buildProductCard(Product product){
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        color: Colors.white,
        child: Center(
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
                        //color:Color(0xFFF1F3F8),
                        // color: Colors.white10,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        icon: Icon(
                          product.isFavorite ? Icons.favorite : 
                          Icons.favorite_border, 
                          color: Colors.pinkAccent
                        ),
                        onPressed: (){
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
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '₺${product.price}',
                style: const TextStyle(color:Colors.black, fontSize: 18),
              ),
            ],
          ),
        )
      ),
    );
  }
}


