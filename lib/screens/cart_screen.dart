import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/widgets/theme_color.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DevThemeConfig.devAppTheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(color: DevThemeConfig.devTextColor),
        ),
        backgroundColor: theme.primaryColor,
        iconTheme: IconThemeData(color: DevThemeConfig.devTextColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userID', isEqualTo: currentUser?.uid)
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

          final List<Map<String, dynamic>> cartItems = cartDocs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'id': doc.id,
              'bookRef': data['bookID'],
              'quantity': data['quantity'] ?? 0,
              'userID': data['userID'],
            };
          }).toList();

          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (ctx, i) {
              final item = cartItems[i];
              final bookRef = item['bookRef'] as DocumentReference?;

              if (bookRef == null) {
                return const Text('Invalid Book Reference');
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: FutureBuilder<DocumentSnapshot>(
                    future: bookRef.get(),
                    builder: (context, bookSnapshot) {
                      if (bookSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text('Loading...');
                      }

                      if (!bookSnapshot.hasData || bookSnapshot.hasError) {
                        return const Text('Book not found');
                      }

                      final bookData =
                          bookSnapshot.data!.data() as Map<String, dynamic>?;
                      if (bookData == null) {
                        return const Text('Book data is invalid');
                      }

                      final priceData =
                          bookData['price'] as Map<String, dynamic>? ?? {};
                      final amount = priceData['amount'] ?? 0.0;
                      // ignore: unused_local_variable
                      final currency = priceData['currency'] ?? 'USD';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookData['title'] ?? 'Unnamed Book',
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            ' ${amount.toStringAsFixed(2)}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      );
                    },
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        'Quantity: ${item['quantity']}',
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () {
                          if (item['quantity'] > 1) {
                            FirebaseFirestore.instance
                                .collection('cart')
                                .doc(item['id'])
                                .update({'quantity': item['quantity'] - 1});
                          }
                        },
                        icon: Icon(Icons.remove_circle,
                            color: theme.primaryColor),
                      ),
                    ],
                  ),
                  trailing: FutureBuilder<DocumentSnapshot>(
                    future: bookRef.get(),
                    builder: (context, bookSnapshot) {
                      if (bookSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Text('Calculating...');
                      }

                      if (!bookSnapshot.hasData || bookSnapshot.hasError) {
                        return const Text('--');
                      }

                      final bookData =
                          bookSnapshot.data!.data() as Map<String, dynamic>?;
                      if (bookData == null) {
                        return const Text('Invalid data');
                      }

                      final priceData =
                          bookData['price'] as Map<String, dynamic>? ?? {};
                      final amount = priceData['amount'] ?? 0.0;
                      final totalPrice = amount * item['quantity'];

                      return Text(
                        '\$${totalPrice.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
