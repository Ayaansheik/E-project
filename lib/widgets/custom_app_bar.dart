import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Define premium colors
    const Color premiumGreen =
        Color(0xFF006400); // Dark Green for AppBar background
    const Color gold =
        Color(0xFFFFD700); // Gold accent color for icons and text

    // Set the status bar color to match the app bar
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: premiumGreen, // Set the status bar color
      statusBarIconBrightness:
          Brightness.light, // Ensure icons are visible on dark background
      statusBarBrightness: Brightness.dark, // For iOS devices
    ));

    return SliverAppBar(
      title: Text(
        'BOOKIFIER',
        style: TextStyle(
          color: gold,
          backgroundColor: premiumGreen,
          fontSize: 18, // Reduced font size
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          shadows: [
            Shadow(
              blurRadius: 102.0,
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: premiumGreen,
      expandedHeight: 45.0, // Decreased height of the app bar
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                premiumGreen.withOpacity(0.9),
                premiumGreen.withOpacity(0.6),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      elevation: 8,
      pinned: true,
      floating: false,

      snap: false,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.shopping_cart,
            color: gold,
            size: 26,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/cart');
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.food_bank_rounded,
            color: gold,
            size: 27,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/all-products');
          },
        ),
        PopupMenuButton(
          icon: const Icon(
            Icons.more_vert,
            color: gold,
            size: 26,
          ),
          onSelected: (value) {
            if (value == 'login') {
              Navigator.of(context).pushNamed('/login');
            } else if (value == 'register') {
              Navigator.of(context).pushNamed('/register');
            } else if (value == 'userprofile') {
              Navigator.of(context).pushNamed('/userprofile');
            } else if (value == 'signOut') {
              _signOut(context);
            }
          },
          itemBuilder: (context) {
            // Check if user is signed in or not
            User? user = FirebaseAuth.instance.currentUser;
            return [
              if (user != null) // Show login and register if not signed in
                const PopupMenuItem(
                  value: 'userprofile',
                  child: Text(
                    'User Profile',
                    style: TextStyle(color: premiumGreen),
                  ),
                ),
              if (user == null) // Show login and register if not signed in
                const PopupMenuItem(
                  value: 'login',
                  child: Text(
                    'Login',
                    style: TextStyle(color: premiumGreen),
                  ),
                ),
              if (user == null)
                const PopupMenuItem(
                  value: 'register',
                  child: Text(
                    'Register',
                    style: TextStyle(color: premiumGreen),
                  ),
                ),
              if (user != null) // Show Sign Out if user is signed in
                const PopupMenuItem(
                  value: 'signOut',
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: premiumGreen),
                  ),
                ),
            ];
          },
        ),
      ],
    );
  }

  // Sign out method
  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully signed out')),
      );
      Navigator.of(context).pushReplacementNamed(
          '/login'); // Redirect to login page after sign-out
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }
}
