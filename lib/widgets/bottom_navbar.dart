import 'package:flutter/material.dart';
import 'package:mad_app/screens/cart_page.dart';

// Reusable Bottom Navigation Bar Widget
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == 1) {
          // When Cart is tapped, navigate to CartPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartPage(cartItems: [],), // Ensure CartPage is imported
            ),
          );
        } else {
          onItemTapped(index); // Default navigation behavior
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
