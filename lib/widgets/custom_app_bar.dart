import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/widgets/theme_color.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Use custom theme colors from DevThemeConfig
    final Color devPrimaryColor =
        DevThemeConfig.devPrimaryColor; // Dark Blue for AppBar background
    final Color gold = DevThemeConfig.devTextColor; // Teal for accents

    // Set the status bar color to match the app bar for a premium look
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          devPrimaryColor, // Set the status bar color to premium green
      statusBarIconBrightness:
          Brightness.light, // Light icons for dark background
      statusBarBrightness: Brightness.dark, // For iOS devices
    ));

    return SliverAppBar(
      title: Text(
        'BOOKIFIER',
        style: TextStyle(
          color: gold,
          backgroundColor: devPrimaryColor,
          fontSize: 20, // Slightly larger font size for a more premium look
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          shadows: [
            Shadow(
              blurRadius: 8.0,
              color: Colors.black.withOpacity(0.5),
              offset: Offset(0, 2),
            ),
          ],
        ),
      ),
      automaticallyImplyLeading: false,
      backgroundColor: devPrimaryColor,
      expandedHeight: 60.0, // Slightly larger height for a more premium feel
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                devPrimaryColor.withOpacity(0.9),
                devPrimaryColor.withOpacity(0.6),
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
          icon: Icon(
            Icons.shopping_cart,
            color: gold,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/cart');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.food_bank_rounded,
            color: gold,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/all-products');
          },
        ),
        PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: gold,
            size: 28,
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
              if (user != null) // Show profile if user is signed in
                PopupMenuItem(
                  value: 'userprofile',
                  child: Text(
                    'User Profile',
                    style: TextStyle(color: devPrimaryColor),
                  ),
                ),
              if (user == null) // Show login and register if not signed in
                PopupMenuItem(
                  value: 'login',
                  child: Text(
                    'Login',
                    style: TextStyle(color: devPrimaryColor),
                  ),
                ),
              if (user == null)
                PopupMenuItem(
                  value: 'register',
                  child: Text(
                    'Register',
                    style: TextStyle(color: devPrimaryColor),
                  ),
                ),
              if (user != null) // Show Sign Out if user is signed in
                PopupMenuItem(
                  value: 'signOut',
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: devPrimaryColor),
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
