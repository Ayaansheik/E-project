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
                  color: theme.hintColor,
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
              leading: Icon(Icons.shopping_cart, color: theme.hintColor),
              title: Text('Cart', style: TextStyle(color: theme.hintColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/cart');
              },
            ),
            ListTile(
              leading: Icon(Icons.local_shipping, color: theme.hintColor),
              title: Text('Order Tracking',
                  style: TextStyle(color: theme.hintColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/trackingorder');
              },
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts, color: theme.hintColor),
              title: Text('User', style: TextStyle(color: theme.hintColor)),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/userprofile');
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

            // Login or Sign Out option
            FutureBuilder<User?>(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, snapshot) {
                // Show loading spinner while checking user status
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    leading: CircularProgressIndicator(
                      color: theme.hintColor,
                    ),
                    title: Text(
                      'Loading...',
                      style: TextStyle(color: theme.hintColor),
                    ),
                  );
                }

                // If user is not logged in, show Login option
                if (snapshot.data == null) {
                  return ListTile(
                    leading: Icon(Icons.login, color: theme.hintColor),
                    title:
                        Text('Login', style: TextStyle(color: theme.hintColor)),
                    onTap: () {
                      Navigator.of(context).pop(); // Close the drawer
                      Navigator.pushNamed(context, '/login');
                    },
                  );
                }

                // If user is logged in, show Sign Out option
                return ListTile(
                  leading: Icon(Icons.exit_to_app, color: theme.hintColor),
                  title: Text('Sign Out',
                      style: TextStyle(color: theme.hintColor)),
                  onTap: () async {
                    // Show a loading dialog while signing out
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme.hintColor,
                          ),
                        );
                      },
                    );

                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pop(); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Successfully signed out')),
                      );
                      Navigator.pushReplacementNamed(context, '/login');
                    } catch (e) {
                      Navigator.of(context).pop(); // Close the dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error signing out: $e')),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
