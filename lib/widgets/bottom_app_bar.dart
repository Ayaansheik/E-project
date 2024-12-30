import 'package:flutter/material.dart';
import 'package:myapp/widgets/theme_color.dart';

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current theme from context
    final theme = DevThemeConfig.devAppTheme;

    return Container(
      height: 65.0, // Increased height for a more premium, spacious feel
      decoration: BoxDecoration(
        color:
            theme.primaryColor.withOpacity(0.9), // Use primary color from theme
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), // Rounded corners for a luxurious look
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.15), // Subtle shadow for a premium effect
            blurRadius: 12.0, // Larger blur for a more elegant look
            offset:
                Offset(0, -4), // Adjust the offset to make the shadow softer
          ),
        ],
      ),
      child: BottomAppBar(
        elevation: 0, // No default elevation since we use custom styling
        color: Colors.transparent, // Keep the background transparent
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home,
                  color: DevThemeConfig.devTextColor), // Use theme icon color
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            IconButton(
              icon: Icon(Icons.search,
                  color: DevThemeConfig.devTextColor), // Use theme icon color
              onPressed: () {
                Navigator.pushNamed(context, '/all-products');
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart,
                  color: DevThemeConfig.devTextColor), // Use theme icon color
              onPressed: () {
                Navigator.pushNamed(
                    context, '/cart'); // Navigate to the cart screen
              },
            ),
            IconButton(
              icon: Icon(Icons.menu,
                  color: DevThemeConfig.devTextColor), // Use theme icon color
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
