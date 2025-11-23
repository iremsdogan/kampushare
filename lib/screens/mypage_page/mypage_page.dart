import 'package:flutter/material.dart';
import 'package:kampushare/providers/products_provider.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'package:kampushare/routes/routes.dart';
import 'package:kampushare/widgets/product_grid.dart';
import '../../models/user_model.dart';
import 'package:provider/provider.dart';

class MypagePage extends StatefulWidget{
  const MypagePage ({super.key});

  @override
  State<MypagePage> createState() => _MypagePageState();
}

class _MypagePageState extends State<MypagePage> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  int _selectedItem = 4;

  void _onItemTapped(int index) {
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;

    if (index == 0) {
      Navigator.pushNamed(context, AppRoutes.home, arguments: user);
    } else if (index == 1) {
      Navigator.pushNamed(context, AppRoutes.favorites, arguments: user);
    } else if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.addproduct);
    } else if (index == 3) {
      Navigator.pushNamed(context, AppRoutes.chatmenu, arguments: user);
    }

    setState(() {
      _selectedItem = index;
    });
  }
  @override
  void initState() {
      super.initState();
      _tabController = TabController(length: 2, vsync: this);
      _tabController.index = 0;
  }

  @override
  Widget build(BuildContext context){
    final user = ModalRoute.of(context)!.settings.arguments as UserModel?;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Kullanıcı bilgisi bulunamadı.")));
    }

    final allProducts = context.watch<ProductsProvider>().products;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F8),
      body: CustomScrollView(
        slivers:[
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: const SizedBox(height:20)),
          SliverToBoxAdapter(child: _buildTabs()),
          SliverToBoxAdapter(child: const SizedBox(height:15)),
          SliverToBoxAdapter(child: _buildFilterRow()),
          SliverToBoxAdapter(child: const SizedBox(height:10)),
          SliverToBoxAdapter(child: _buildCampaignCard()),
          const SliverToBoxAdapter(child: SizedBox(height:10)),
          ProductGrid(
            products: allProducts,
            isSliver: true,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          const SliverToBoxAdapter(child: SizedBox(height:80)),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedItem,
        onTap: _onItemTapped,
      ),
    );
  }
  Widget _buildHeader(){
    final user = ModalRoute.of(context)!.settings.arguments as UserModel;
    return Container(
      padding: const EdgeInsets.fromLTRB(16,40,16,10),
      color:Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_back),
              Row(
                children: [
                  Icon(Icons.share_outlined),
                  SizedBox(width:15),
                  Icon(Icons.settings_outlined),
                  SizedBox(width:15),
                  Icon(Icons.notifications_outlined),
                ],
              )
            ],
          ),
          const SizedBox(height:20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius:40,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=5'),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.addproduct);
                      },
                      child: const CircleAvatar(
                        radius:13,
                        backgroundColor: Colors.teal,
                        child: Icon(Icons.add, size:16, color:Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15), 
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _statItem("15", "Satış"),
                    _statItem("15", "Takipçi"),
                    _statItem("2", "Takip"),
                    _statItem("4", "Favori"),
                  ],
                ),
                ),
              ),
            ],
          ),
          const SizedBox(height:15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "@${user.username}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  print("Puan detayına gidildi");
                },
                child: const Row(
                children: [
                  Icon(Icons.star, color:Colors.amber, size:20),
                  SizedBox(width:5),
                  Text( // şimdilik sabit puan
                    "4.8",
                    style: TextStyle(
                      fontSize:16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "  (9)",
                    style: const TextStyle(
                      fontSize:14,
                      color:Colors.black87,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size:13,
                    color:Colors.black87,
                  ),
                ],
              ),
              ),
              const SizedBox(height:5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal:8, vertical:4),
                decoration: BoxDecoration(
                  color:Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    Icon(
                      Icons.verified, 
                      color: Colors.purpleAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "Süper Satıcı",
                      style: TextStyle(
                        color:Colors.black,
                        fontSize:14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ], 
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _statItem(String value, String label){
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize:18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height:2),
        Text(
          label,
          style: const TextStyle(
            fontSize:14,
            color:Colors.black54,
          ),
        ),
      ],
    );
  }
  Widget _buildTabs() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.teal,
          labelColor: Colors.teal,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Mağazam"),
            Tab(text: "Ürünlerim"),
          ],
        ),
      ],
    );
  }
  Widget _buildFilterRow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("9 Ürün", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Icon(Icons.grid_view),
              SizedBox(width: 8),
              Text("Tümü"),
              SizedBox(width: 20),
              Icon(Icons.filter_list),
              SizedBox(width: 5),
              Text("Filtrele"),
            ],
          )
        ],
      ),
    );
  }
  Widget _buildCampaignCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.pinkAccent, Colors.orangeAccent],
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.add_circle, color: Colors.white, size: 40),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.addproduct);
            },
            child: const Expanded(
              child: Text(
                "Sonbahar ürünlerini hemen yükle!",
                style: TextStyle(color: Colors.white, fontSize: 14),
                
              ),
            ),
          ),
          const SizedBox(width: 60),
          const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ],
      ),
    );
  }

}