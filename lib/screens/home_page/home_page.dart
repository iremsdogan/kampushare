import 'package:flutter/material.dart';
import 'package:kampushare/widgets/custom_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/products_provider.dart';
import 'package:kampushare/screens/product_detail_page/product_detail_page.dart';
import '../../models/user_model.dart';
import '../../models/product_model.dart';
import '../../routes/routes.dart';

class HomePage extends StatefulWidget{

  final UserModel user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{

  late Future<void> _loadProductsFuture;
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
      Navigator.pushNamed(context, AppRoutes.favorites, arguments: widget.user);
    }
    else if(item == 2){
      Navigator.pushNamed(context, AppRoutes.addproduct);
    }
    else if(item == 3){
      Navigator.pushNamed(context, AppRoutes.chatmenu, arguments: widget.user);
    }
    else if(item == 4){
      Navigator.pushNamed(context, AppRoutes.profilemenu, arguments: widget.user);
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

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: _isLoading ? const Center(child: CircularProgressIndicator(),) : 
        Container(
          decoration: const BoxDecoration(
              color: Color(0xFFF1F3F8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const TabBar(
                indicatorColor: Colors.teal,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.teal,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Bana Özel",),
                  Tab(text: "Keşfet",),
                ]
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildProductGrid(products),  // Bana Özel
                    _buildExploreGrid(products),  // Keşfet
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedItem, 
          onTap: _onItemTapped,
        ),    ),
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
            hintText: 'Selam, ${widget.user.name}', hintStyle: const TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildProductGrid(List<Product> products){
    return Column(
        children: [ 
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20, top:10),
            child: const Text("Senin için seçtiklerimiz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,8),
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
      
    );
  }

  //şimdilik bana özel ile aynı grid yapısı kullanıldı
  Widget _buildExploreGrid(List<Product> products){
    return Padding(
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
                      product.coverImageUrl, 
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
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
                          product.isFavorite ? Icons.favorite : 
                          Icons.favorite_border, 
                          color: Colors.black
                        ),
                        onPressed: (){
                          context.read<ProductsProvider>().toggleFavorite(product.productId);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                product.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '₺${product.price.toString()}',
                style: const TextStyle(color:Colors.black, fontSize: 18),
              ),
            ],
          ),
        )
      ),
    );
  }
}
