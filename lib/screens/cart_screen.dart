import 'package:flutter/material.dart';
import 'package:myapp/screens/checkout_screen.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    const Color premiumGreen =
        Color(0xFF006400); // Dark Green for AppBar background
    const Color gold = Color(0xFFFFD700);
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(color: gold),
        ),

        backgroundColor: Theme.of(context).primaryColor, // Use premiumGreen
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          subtitle: Text(
                            'Quantity: ${cartItem.quantity}',
                            style: Theme.of(context).textTheme.bodyLarge,
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
                                style: Theme.of(context).textTheme.bodyMedium,
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
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
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
                          backgroundColor: Theme.of(context).hintColor, // gold
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
