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
          const SliverToBoxAdapter(child: SizedBox(height:20)),
          SliverToBoxAdapter(child: _buildTabs()),
          const SliverToBoxAdapter(child: SizedBox(height:15)),
          SliverToBoxAdapter(child: _buildFilterRow()),
          const SliverToBoxAdapter(child: SizedBox(height:10)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              const Row(
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
                    top: -2,
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
                  Positioned(
                    bottom: -12,
                    left: 0,
                    right: 0,
                    child: InkWell(
                        onTap: () {
                          print("Puan detayına gidildi");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.green.shade600,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color:Colors.amber, size:20),
                              SizedBox(width:5),
                              Text( // şimdilik sabit puan
                                "4.8",
                                style: TextStyle(
                                  fontSize:15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "  (9)",
                                style: TextStyle(
                                  fontSize:13,
                                  color:Colors.black87,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
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
                    _statItem("15", "Satış", () {print("Satışlara gidildi");}),
                    _statItem("15", "Takipçi", () {Navigator.pushNamed(context, AppRoutes.followers);}),
                    _statItem("2", "Takip", () {Navigator.pushNamed(context, AppRoutes.following);}),
                    _statItem("4", "Favori", () {print("Kullanıcının favorilerine gidildi");}),
                  ],
                ),
                ),
              ),
            ],
          ),
          const SizedBox(height:20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "@${user.username}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 20),
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
                        SizedBox(width: 4),
                        Text(
                          "Kampüsün Yıldızı",
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
        ],
      ),
    );
  }
  Widget _statItem(String value, String label, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
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
      )
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