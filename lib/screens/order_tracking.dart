import 'dart:convert'; // For base64 decoding
import 'dart:typed_data'; // For Uint8List data handling
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/widgets/theme_color.dart'; // Your theme

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DevThemeConfig.devAppTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Order Tracking',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: theme.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<OrderDetail>>(
        future: _fetchOrdersFromFirestore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderTrackingCard(order: orders[index]);
            },
          );
        },
      ),
    );
  }

  Future<List<OrderDetail>> _fetchOrdersFromFirestore() async {
    final List<OrderDetail> orders = [];
    try {
      // Fetch orders from the `order` collection
      final querySnapshot =
          await FirebaseFirestore.instance.collection('order').get();

      for (var orderDoc in querySnapshot.docs) {
        final orderData = orderDoc.data();

        // Fetch book details using bookId reference
        final bookRef = orderData['bookId'] as DocumentReference;
        final bookSnapshot = await bookRef.get();
        final bookData = bookSnapshot.data() as Map<String, dynamic>;

        // Fetch user details using userId reference
        final userRef = orderData['userID'] as DocumentReference;
        final userSnapshot = await userRef.get();
        final userData = userSnapshot.data() as Map<String, dynamic>;

        // Add OrderDetail instance to the list
        orders.add(OrderDetail(
          title: bookData['title'] ?? 'Unknown Title',
          quantity: orderData['quantity'] ?? 0,
          price: bookData['price'] is num
              ? (bookData['price'] as num).toDouble()
              : 0.0,
          stage: orderData['stage'] ?? 'Unknown',
          daysLeft: orderData['days_left'] ?? 0,
          imageUrl: bookData['image'] ?? '',
          userName: userData['username'] ?? 'Unknown User',
        ));
      }

      return orders;
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }
}

class OrderDetail {
  final String title;
  final int quantity;
  final double price;
  final String stage;
  final int daysLeft;
  final String imageUrl;
  final String userName;

  OrderDetail({
    required this.title,
    required this.quantity,
    required this.price,
    required this.stage,
    required this.daysLeft,
    required this.imageUrl,
    required this.userName,
  });
}

class OrderTrackingCard extends StatelessWidget {
  final OrderDetail order;

  const OrderTrackingCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Uint8List? decodedImage;
    try {
      decodedImage = base64Decode(order.imageUrl);
    } catch (e) {
      // Handle decoding errors gracefully
      print('Error decoding image: $e');
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: decodedImage != null
                      ? Image.memory(
                          decodedImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _placeholderImage();
                          },
                        )
                      : _placeholderImage(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text('Quantity: ${order.quantity}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black54)),
                  Text(
                    'Total Price: \$${(order.quantity * order.price).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Status: ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Chip(
                        label: Text(
                          order.stage,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: order.stage == 'Shipped'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ],
                  ),
                  Text('Days Left: ${order.daysLeft}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87)),
                  Text('Ordered By: ${order.userName}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image, size: 50),
    );
  }
}
