import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/theme_color.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme from context
    final theme = DevThemeConfig.devAppTheme;

    return Drawer(
      child: Container(
        color: theme.primaryColor, // Use the primary color from the theme
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Drawer Header
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: theme.primaryColor),
              accountName: Text(
                'BOOKIFIER',
                style: TextStyle(
                  color: theme
                      .hintColor, // Use the accent color for the account name
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                'Welcome back!',
                style: TextStyle(color: theme.hintColor),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: theme.hintColor,
                child: Icon(
                  Icons.book,
                  color: theme.primaryColor,
                ),
              ),
            ),

            // Navigation list items
            ListTile(
              leading: Icon(Icons.home, color: theme.hintColor),
              title: Text('Home', style: TextStyle(color: theme.hintColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: theme.hintColor),
              title: Text('Search New Deals',
                  style: TextStyle(color: theme.hintColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/new-deals');
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart, color: theme.hintColor),
              title: Text('Cart', style: TextStyle(color: theme.hintColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/cart');
              },
            ),
            // New Order Tracking option
            ListTile(
              leading: Icon(Icons.local_shipping, color: theme.hintColor),
              title: Text('Order Tracking',
                  style: TextStyle(color: theme.hintColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/trackingorder');
                // Navigator.pushNamed(context, '/order_tracking');
              },
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts, color: theme.hintColor),
              title: Text('User', style: TextStyle(color: theme.hintColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              leading: Icon(Icons.food_bank_rounded, color: theme.hintColor),
              title: Text('All Products',
                  style: TextStyle(color: theme.hintColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/all-products');
              },
            ),

            // Conditional sign-in options
            ListTile(
              leading: Icon(Icons.login, color: theme.hintColor),
              title: Text('Login', style: TextStyle(color: theme.hintColor)),
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
              leading: Icon(Icons.exit_to_app, color: theme.hintColor),
              title: Text('Sign Out', style: TextStyle(color: theme.hintColor)),
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
