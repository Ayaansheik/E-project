import 'package:flutter/material.dart';
import 'package:myapp/screens/checkout_screen.dart';
import 'package:myapp/widgets/theme_color.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DevThemeConfig.devAppTheme; // Get the custom theme
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(
              color:
                  DevThemeConfig.devTextColor), // Use white for the text color
        ),
        backgroundColor: theme.primaryColor, // Use primary color from the theme
        iconTheme: IconThemeData(
          color: DevThemeConfig
              .devTextColor, // Set the back button color to match the primary color
        ),
      ),
      body: cart.items.isEmpty
          ? const Center(child: Text('No items in cart!'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, i) {
                      final cartItem = cart.items.values.toList()[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            cartItem.name,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Quantity: ${cartItem.quantity}',
                            style: theme.textTheme.bodyLarge,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  cart.removeSingleItem(cartItem.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Item removed from cart!'),
                                    ),
                                  );
                                },
                              ),
                              Text(
                                '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              theme.primaryColor, // Use primary color for total
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to CheckoutScreen with cart items and total amount
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CheckoutScreen(
                                cartItems: cart.items.values.toList(),
                                totalAmount: cart.totalAmount,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.hintColor, // gold
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
