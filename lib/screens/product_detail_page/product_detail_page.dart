import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/products.dart';
import '../../providers/products_provider.dart';
import '../chat_page/chat_page.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.network(
                    product.image,
                    height: 500,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: _circleButton(
                    icon: Icons.arrow_back,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: _circleButton(
                    icon: product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    onTap: () => provider.toggleFavorite(product.id),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            product.price % 1 == 0
                                ? "${product.price.toInt()}₺"
                                : "${product.price}₺",
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _buildTag(Icons.checkroom, "label1"),
                          const SizedBox(width: 8),
                          _buildTag(Icons.eco, "label2"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoBox("beden",
                              product.size?.isEmpty ?? true
                                  ? "-"
                                  : product.size!),
                          _buildInfoBox("yükseklik", "-"),
                          _buildInfoBox("genişlik", "-"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        product.description ??
                            "No description available.",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 15),
                              ),
                              onPressed: () {},
                              child: const Text("Sepete Ekle",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFB6F64A),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(
                                        vertical: 15),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ChatPage(),
                                  ),
                                );
                              },
                              child: const Text("Satıcıyla Görüş",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  Widget _buildTag(IconData icon, String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F3F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black54),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
