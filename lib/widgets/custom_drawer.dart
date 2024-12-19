import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Define premium colors
    const Color premiumGreen = Color(0xFF006400); // Dark Green
    const Color gold = Color(0xFFFFD700); // Gold

    return Drawer(
      child: Container(
        color: premiumGreen, // Background color of the drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Drawer Header
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: premiumGreen),
              accountName: Text(
                'BOOKIFIER',
                style: TextStyle(
                  color: gold,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                'Welcome back!',
                style: TextStyle(color: gold),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: gold,
                child: Icon(
                  Icons.book,
                  color: premiumGreen,
                ),
              ),
            ),

            // Navigation list items
            ListTile(
              leading: Icon(Icons.home, color: gold),
              title: Text('Home', style: TextStyle(color: gold)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: gold),
              title: Text('Search New Deals', style: TextStyle(color: gold)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/new-deals');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: gold),
              title: Text('Cart', style: TextStyle(color: gold)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts, color: gold),
              title: Text('User', style: TextStyle(color: gold)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              leading: Icon(Icons.food_bank_rounded, color: gold),
              title: Text('All Products', style: TextStyle(color: gold)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/all-products');
              },
            ),

            // Conditional sign-in options
            ListTile(
              leading: Icon(Icons.login, color: gold),
              title: Text('Login', style: TextStyle(color: gold)),
              onTap: () {
                Navigator.of(context).pop(); // Ensure drawer is closed
                User? user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  Navigator.pushNamed(context, '/login');
                } else {
                  Navigator.pushNamed(context, '/register');
                }
              },
            ),

            // Conditional sign-out option
            ListTile(
              leading: Icon(Icons.exit_to_app, color: gold),
              title: Text('Sign Out', style: TextStyle(color: gold)),
              onTap: () async {
                Navigator.of(context).pop(); // Ensure drawer is closed
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Successfully signed out')),
                  );
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
