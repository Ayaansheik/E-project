import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Products'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder(
        stream: productsRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          }

          final products = snapshot.data?.docs ?? [];

          if (products.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: product['image'] ?? '',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['name'] ?? 'No name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Brand: ${product['brand']}'),
                      Text('Category: ${product['category']}'),
                      Text('Description: ${product['description']}'),
                      Text('Price: \$${product['price']}'),
                    ],
                  ),
                  trailing: product['isNewDeal'] == true
                      ? const Icon(Icons.new_releases, color: Colors.red)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
