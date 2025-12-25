import 'package:flutter/material.dart';

class ProductFilterBar extends StatefulWidget{

  final VoidCallback onSort;
  final VoidCallback onFilter;
  final bool hideSold;
  final VoidCallback onToggleHideSold;

  const ProductFilterBar({
    super.key,
    required this.onSort,
    required this.onFilter,
    required this.hideSold,
    required this.onToggleHideSold,
  });

  @override
  State<ProductFilterBar> createState() => _ProductFilterBarState();
}

class _ProductFilterBarState extends State<ProductFilterBar>{
  @override
  Widget build(BuildContext context){
    return Container(
      color: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _filterButton(
              icon: Icons.compare_arrows_outlined, 
              label: 'Sırala', 
              onTap: widget.onSort
            ),
            const SizedBox(width: 10),
            _filterButton(
              icon: Icons.filter_alt_outlined,
              label: 'Filtrele',
              onTap: widget.onFilter,
            ),
            const SizedBox(width: 10),
            _filterButton(
              icon: widget.hideSold ? Icons.visibility_off : Icons.visibility,
              label: widget.hideSold ? 'Satılanları Göster' : 'Satılanları Gizle',
              onTap: widget.onToggleHideSold,
            ),
          ],
        ),  
      ),
    );
  }
  Widget _filterButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color:Colors.black),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}