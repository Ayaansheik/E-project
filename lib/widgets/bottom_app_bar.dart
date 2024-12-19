import 'package:flutter/material.dart';

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55.0, // Reduced height for a more compact BottomAppBar
      decoration: BoxDecoration(
        color: Color(0xFFFFD700).withOpacity(0.9), // Gold background color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), // Rounded corners for premium look
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8.0,
            offset: Offset(0, -2), // Subtle shadow effect
          ),
        ],
      ),
      child: BottomAppBar(
        elevation: 12, // Remove the default elevation
        color: Colors.transparent, // Transparent to allow custom background
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: const Color(0xFF006400)),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            IconButton(
              icon: Icon(Icons.search, color: const Color(0xFF006400)),
              onPressed: () {
                Navigator.pushNamed(context, '/all-products');
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: const Color(0xFF006400)),
              onPressed: () {
                Navigator.pushNamed(
                    context, '/cart'); // Navigate to the cart screen
              },
            ),
            IconButton(
              icon: Icon(Icons.menu, color: const Color(0xFF006400)),
              onPressed: () {
                // Open the drawer when the menu button is pressed
                Scaffold.of(context).openDrawer(); // This opens the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
