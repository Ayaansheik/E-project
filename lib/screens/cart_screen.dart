import 'dart:convert'; // Import this for base64 decoding
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/screens/checkout_screen.dart';
import 'package:myapp/widgets/theme_color.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DevThemeConfig.devAppTheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Cart',
          style: TextStyle(color: DevThemeConfig.devTextColor),
        ),
        backgroundColor: theme.primaryColor,
        iconTheme: IconThemeData(color: DevThemeConfig.devTextColor),
      ),
      body: currentUser == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_off,
                    size: 100,
                    color: theme.primaryColor.withOpacity(0.7),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Not Logged In',
                    style: theme.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You need to log in to view your cart.',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: theme.hintColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
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
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: DevThemeConfig.devTextColor,
                      ),
                    ),
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
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 100,
                          color: theme.primaryColor.withOpacity(0.7),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Your Cart is Empty',
                          style: theme.textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Looks like you haven’t added any items yet.',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: theme.hintColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
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
                          child: const Text(
                            'Start Shopping',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: DevThemeConfig.devTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

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
                              final price = bookData['price'] ?? {};
                              final amount = price['amount'] ?? 0.0;
                              final totalPrice =
                                  (amount * quantity).toStringAsFixed(2);

                              // Add to total cart price

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
                                        '\$$totalPrice',
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
                      color: theme.primaryColor,
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
                                      userId: '',
                                      cartItems: [],
                                      totalAmount: 22,
                                    ), // Replace with your checkout screen widget
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DevThemeConfig.devTextColor,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                'Checkout',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: DevThemeConfig.devPrimaryColor,
                                ),
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('cart')
                                  .where('userID',
                                      isEqualTo: FirebaseFirestore.instance.doc(
                                          'users/${FirebaseAuth.instance.currentUser!.uid}'))
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Calculating...');
                                }
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return Text(
                                    'Error',
                                    style: theme.textTheme.titleLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: DevThemeConfig.devPrimaryColor,
                                    ),
                                  );
                                }

                                final cartDocs = snapshot.data?.docs ?? [];
                                double totalCartPrice = 0;

                                for (var doc in cartDocs) {
                                  final cartItem =
                                      doc.data() as Map<String, dynamic>;
                                  final quantity = cartItem['quantity'] ?? 0;
                                  final bookRef =
                                      cartItem['bookID'] as DocumentReference?;

                                  if (bookRef != null) {
                                    bookRef.get().then((bookSnapshot) {
                                      if (bookSnapshot.exists) {
                                        final bookData = bookSnapshot.data()
                                            as Map<String, dynamic>;
                                        final price = bookData['price'] ?? {};
                                        final amount = price['amount'] ?? 0.0;
                                        totalCartPrice += amount * quantity;
                                      }
                                    });
                                  }
                                }

                                return Text(
                                  'Total: \$${totalCartPrice.toStringAsFixed(2)}',
                                  style: theme.textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: DevThemeConfig.devPrimaryColor,
                                  ),
                                );
                              },
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
