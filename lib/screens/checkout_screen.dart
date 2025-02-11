import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/widgets/theme_color.dart';

class CheckoutScreen extends StatelessWidget {
  final List<QueryDocumentSnapshot<Object?>> cartDetails;
  final double totalPrice;

  const CheckoutScreen({
    super.key,
    required this.cartDetails,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = DevThemeConfig.devAppTheme;
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Checkout',
            style: TextStyle(color: DevThemeConfig.devTextColor),
          ),
          backgroundColor: theme.primaryColor,
          iconTheme: IconThemeData(color: DevThemeConfig.devTextColor),
        ),
        body: Center(
          child: Text(
            'You need to log in to proceed with checkout.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: DevThemeConfig.devTextColor),
        ),
        backgroundColor: theme.primaryColor,
        iconTheme: IconThemeData(color: DevThemeConfig.devTextColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartDetails.length,
              itemBuilder: (context, index) {
                final item = cartDetails[index].data() as Map<String, dynamic>;
                final bookRef = item['bookID'] as DocumentReference?;
                final quantity = (item['quantity'] ?? 0) as int;

                if (bookRef == null) {
                  return const ListTile(
                    title: Text('Invalid book reference'),
                  );
                }

                return FutureBuilder<DocumentSnapshot>(
                  future: bookRef.get(),
                  builder: (context, bookSnapshot) {
                    if (bookSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const ListTile(title: Text('Loading...'));
                    }
                    if (!bookSnapshot.hasData || bookSnapshot.hasError) {
                      return const ListTile(title: Text('Book not found'));
                    }

                    final bookData =
                        bookSnapshot.data!.data() as Map<String, dynamic>?;
                    if (bookData == null) {
                      return const ListTile(
                          title: Text('Book data not available'));
                    }

                    final price = (bookData['price'] != null &&
                            bookData['price'] is Map<String, dynamic>)
                        ? (bookData['price']['amount'] is num
                            ? (bookData['price']['amount'] as num).toDouble()
                            : 0.0)
                        : 0.0;

                    String base64Image = bookData['image'] ?? '';
                    ImageProvider image = base64Image.isNotEmpty
                        ? MemoryImage(base64Decode(base64Image))
                        : const AssetImage('assets/default_book_image.png')
                            as ImageProvider;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          bookData['title'] ?? 'Unnamed Book',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        subtitle: Text(
                          'Quantity: $quantity',
                          style: theme.textTheme.bodyMedium,
                        ),
                        trailing: Text(
                          '\$${(price * quantity).toStringAsFixed(2)}',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: theme.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Mode of Payment: Cash on Delivery',
              style: theme.textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final batch = FirebaseFirestore.instance.batch();

                for (var doc in cartDetails) {
                  final bookRef = doc['bookID'] as DocumentReference?;

                  if (bookRef == null) {
                    // Skip this cart item if book reference is invalid
                    continue;
                  }

                  // Fetch the book document to get the price
                  final bookSnapshot = await bookRef.get();
                  final bookData = bookSnapshot.data() as Map<String, dynamic>?;

                  if (bookData == null ||
                      !bookData.containsKey('price') ||
                      bookData['price'] == null) {
                    // If the price field is missing or null, log an error and continue
                    print(
                        'Error: Price field is missing for book ${bookRef.id}');
                    continue;
                  }

                  final price = (bookData['price']['amount'] is num
                      ? bookData['price']['amount'] as num
                      : 0.0);

                  // Proceed with adding the order
                  final orderRef =
                      FirebaseFirestore.instance.collection('orderitems').doc();
                  batch.set(orderRef, {
                    'bookID': bookRef,
                    'price': price,
                    'quantity': doc['quantity'],
                    'status': 'pending',
                    'userID': FirebaseAuth.instance.currentUser!.uid,
                  });

                  // Delete the cart item after placing the order
                  batch.delete(doc.reference);
                }

                await batch.commit();

                // Show order success popup
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Order Placed'),
                      content: const Text(
                          'Your order has been placed successfully!'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pushReplacementNamed('/trackingorder');
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to place the order: $e')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DevThemeConfig.devPrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            ),
            child: const Text(
              'Place Order',
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
}
