import 'dart:convert'; // Import this for base64 decoding
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screens/checkout_screen.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/widgets/theme_color.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  // Function to calculate the total price
  double getTotalPrice(List<QueryDocumentSnapshot> cartDocs) {
    double totalPrice = 0.0;

    for (var doc in cartDocs) {
      final cartItem = doc.data() as Map<String, dynamic>;
      final quantity = cartItem['quantity'] ?? 0;
      final priceMap =
          cartItem['price'] as Map<String, dynamic>?; // Ensure price is a map
      final price =
          priceMap?['amount']?.toDouble() ?? 0.0; // Extract amount safely

      totalPrice += (quantity * price);
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    final theme = DevThemeConfig.devAppTheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(color: DevThemeConfig.devBackgroundColor),
        ),
        backgroundColor: theme.primaryColor,
        iconTheme: IconThemeData(color: DevThemeConfig.devTextColor),
      ),
      body: currentUser == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please log in to view your cart.',
                    style: TextStyle(color: DevThemeConfig.devPrimaryColor),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to login screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cart')
                  .where('userID',
                      isEqualTo: FirebaseFirestore.instance
                          .doc('users/${currentUser.uid}'))
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading cart items.'));
                }

                final cartDocs = snapshot.data?.docs ?? [];

                if (cartDocs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, size: 80),
                        const SizedBox(height: 16),
                        Text(
                          'Your cart is empty!',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }

                final totalPrice = getTotalPrice(cartDocs);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartDocs.length,
                        itemBuilder: (ctx, i) {
                          final cartItem =
                              cartDocs[i].data() as Map<String, dynamic>;
                          final bookRef =
                              cartItem['bookID'] as DocumentReference?;
                          final quantity = cartItem['quantity'] ?? 0;

                          return FutureBuilder<DocumentSnapshot>(
                            future: bookRef?.get(),
                            builder: (context, bookSnapshot) {
                              if (bookSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const ListTile(
                                  title: Text('Loading...'),
                                );
                              }

                              if (!bookSnapshot.hasData ||
                                  bookSnapshot.hasError ||
                                  bookSnapshot.data?.data() == null) {
                                return const ListTile(
                                  title: Text('Book not found'),
                                );
                              }

                              final bookData = bookSnapshot.data!.data()
                                  as Map<String, dynamic>;
                              final priceData =
                                  bookData['price'] as Map<String, dynamic>?;
                              final amount =
                                  priceData?['amount']?.toDouble() ?? 0.0;
                              final itemTotalPrice =
                                  (amount * quantity).toStringAsFixed(2);

                              return Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(12),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      base64Decode(bookData['image'] ?? ''),
                                      fit: BoxFit.cover,
                                      width: 60,
                                      height: 60,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.book,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    bookData['title'] ?? 'Unnamed Book',
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove),
                                        color: DevThemeConfig.devPrimaryColor,
                                        onPressed: quantity > 1
                                            ? () {
                                                cartDocs[i].reference.update(
                                                    {'quantity': quantity - 1});
                                              }
                                            : null,
                                      ),
                                      Text(
                                        '$quantity',
                                        selectionColor:
                                            DevThemeConfig.devPrimaryColor,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        color: DevThemeConfig.devPrimaryColor,
                                        onPressed: () {
                                          cartDocs[i].reference.update(
                                              {'quantity': quantity + 1});
                                        },
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '\$$itemTotalPrice',
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    BottomAppBar(
                      elevation: 10,
                      color: theme.canvasColor, // Matches the screen background
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                      cartDetails: cartDocs,
                                      totalPrice: totalPrice,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DevThemeConfig.devPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                  vertical: 15,
                                ),
                              ),
                              child: Text(
                                'Checkout',
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total:',
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: theme.hintColor,
                                    ),
                                  ),
                                  Text(
                                    '\$${totalPrice.toStringAsFixed(2)}',
                                    style: theme.textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: DevThemeConfig.devPrimaryColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
