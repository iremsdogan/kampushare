import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget{
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key, required this.currentIndex, required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.black,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.home_outlined),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.favorite_border_outlined),
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.pinkAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: 'Add Product',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.messenger_outline_sharp),
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.person_outline_outlined),
            ),
            label: 'Profile',
          ),
        ],
      );
  }
}