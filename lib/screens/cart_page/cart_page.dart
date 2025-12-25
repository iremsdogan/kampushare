import 'package:flutter/material.dart';
import 'package:kampushare/services/cart_service.dart';
import '../../models/product_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0.4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Sepetim (${_cartService.items.length} Ürün)",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.info_outline, color: Colors.teal),
          )
        ],
      ),
      body: _cartService.items.isEmpty
          ? const Center(
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
                          'Henüz sepete ürün eklemediniz', 
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                            color: Colors.grey
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Beğendiğiniz ürünleri sepete ekleyin', 
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.grey
                          ),
                        ),
                      ],
                    ),
                  ) 
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Şimdilik ilk ürünün satıcısını gösteriyoruz
                  _sellerHeader(),

                  ..._cartService.items.map((product) => _buildDismissibleCartItem(product)),
                  _bulkDiscountButton(),
                  const SizedBox(height: 20),

                  /// SATICININ DİĞER ÜRÜNLERİ
                  _otherProducts(),

                  const SizedBox(height: 120),
                ],
              ),
            ),
      bottomSheet: _cartService.items.isNotEmpty ? _contactSellerBar() : null,
    );
  }

  Widget _sellerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _cartService.toggleAllSelection(),
            child: Icon(
              _cartService.areAllSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: _cartService.areAllSelected ? Colors.teal : Colors.grey,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=55"),
          ),
          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              "kullanıcı5255",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "10",
              style: TextStyle(
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDismissibleCartItem(Product product) {
    void _deleteItem() {
      _cartService.remove(product.productId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product.title} sepetten kaldırıldı.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    return Slidable(
      key: Key(product.productId),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        dismissible: DismissiblePane(onDismissed: _deleteItem),
        children: [
          SlidableAction(
            onPressed: (context) => _deleteItem(),
            backgroundColor: Colors.red,
            foregroundColor: Color(0xFFFFFFFF),
            icon: Icons.delete,
            label: 'Sil',
          ),
        ],
      ),
      child: _cartItem(product),
    );
  }

  Widget _cartItem(Product product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _cartService.toggleSelection(product.productId),
                child: Icon(
                  _cartService.isSelected(product.productId) ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: _cartService.isSelected(product.productId) ? Colors.teal : Colors.grey,
                  size: 22),
              ),
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image(
                  width: 90,
                  height: 110,
                  fit: BoxFit.cover,
                  image: NetworkImage(product.coverImageUrl),
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 90),
                ),
              )
            ],
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(
                  product.condition ?? "Belirtilmemiş",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "₺${product.price.toStringAsFixed(2)} ",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulkDiscountButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          side: const BorderSide(color: Colors.teal, width: 1.7),
        ),
        onPressed: () {},
        child: const Text(
          "Toplu İndirim İste",
          style: TextStyle(
            color: Colors.teal,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _otherProducts() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFEFFEF5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Satıcının Diğer Ürünleri",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: const Image(
                  width: 80,
                  height: 100,
                  fit: BoxFit.cover,
                  image: NetworkImage("https://i.imgur.com/u5YgZ2F.jpeg"),
                ),
              ),
              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      "+ Ekle",
                      style: TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "115",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

   Widget _contactSellerBar() {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                "₺${_cartService.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                 minimumSize: const Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: Row(
                children: [
                  const Text(
                    "Satıcıyla İletişime Geç ",
                    style: TextStyle(fontSize: 17, color:Color(0xFFFFFFFF)),
                  ),
                  Icon( 
                    Icons.arrow_forward, 
                    size: 20, 
                    color: Color(0xFFFFFFFF).withOpacity(1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }
}
