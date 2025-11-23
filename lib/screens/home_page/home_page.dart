import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kampushare/widgets/custom_bottom_nav_bar.dart';
import 'package:kampushare/widgets/product_grid.dart';
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
  bool _isLoading = true;
  int _selectedItem = 0;
  String? _selectedCategory;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

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
  void dispose(){
      _debounce?.cancel();
      super.dispose();
  }

  @override
  Widget build(BuildContext context){

    final allProducts = context.watch<ProductsProvider>().products;

    final filteredProducts = allProducts.where((p) {
      final matchesCategory = _selectedCategory == null || p.categoryName == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || p.title.toLowerCase().contains(_searchQuery.toLowerCase()) || p.categoryName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    final categories = allProducts.map((p) => p.categoryName).toSet().toList();


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
              _buildSearchBar(categories),
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
                    _buildExploreTab(filteredProducts),
                    ProductGrid(products: filteredProducts),
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

  Widget _buildSearchBar(List<String> categories){
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
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (value){
                  if(_debounce?.isActive ?? false) _debounce!.cancel();
                  _debounce = Timer(const Duration(milliseconds: 300), (){
                    setState(() {
                      _searchQuery = value;
                    });
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search), 
                  prefixIconColor: Colors.grey,
                  hintText: 'Ürün veya kategori ara...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.format_list_bulleted_outlined, color: _selectedCategory != null ? Colors.teal : Colors.grey),
              onPressed: () => _showFilterSheet(context, categories),
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Colors.grey),
              onPressed: (){
                Navigator.pushNamed(context, AppRoutes.notifications, arguments: widget.user);
              },
            ),
          ],
        ),
    );
  }

  void _showFilterSheet(BuildContext context, List<String> categories) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            margin: const EdgeInsets.only(left: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kategoriye Göre Filtrele",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: categories.map((category) {
                    final isSelected = category == _selectedCategory;
                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = selected ? category : null;
                        });
                        Navigator.pop(context);
                      },
                      selectedColor: Colors.teal[100],
                      checkmarkColor: Colors.teal,
                    );
                  }).toList(),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.clear_all),
                  title: const Text("Filtreyi Temizle"),
                  onTap: (){
                    setState(() { _selectedCategory = null; });
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExploreTab(List<Product> products) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20, top: 10),
          margin: const EdgeInsets.only(bottom: 10),
          child: const Text("Senin için seçtiklerimiz", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,),),
        ),
        Expanded(
          child: ProductGrid(products: products, padding: const EdgeInsets.fromLTRB(8, 0, 8, 8)),
        ),
      ],
    );
  }
}
