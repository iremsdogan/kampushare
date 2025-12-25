import 'package:flutter/material.dart';
import 'package:kampushare/models/product_model.dart';
import 'package:kampushare/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final EdgeInsetsGeometry padding;
  final bool isSliver;

  const ProductGrid({
    super.key,
    required this.products,
    this.padding = const EdgeInsets.all(8.0),
    this.isSliver = false,
  });

  @override
  Widget build(BuildContext context) {
    final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.7,
    );

    if (isSliver) {
      return SliverPadding(
        padding: padding,
        sliver: SliverGrid.builder(
          itemCount: products.length,
          gridDelegate: gridDelegate,
          itemBuilder: (context, index) => ProductCard(product: products[index]),
        ),
      );
    }

    return GridView.builder(
      padding: padding,
      itemCount: products.length,
      gridDelegate: gridDelegate,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}