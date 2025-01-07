import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/cart_provider.dart';
import 'package:myapp/widgets/theme_color.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  CategoryProductsScreenState createState() => CategoryProductsScreenState();
}

class CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Map<String, dynamic>> books = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBooksByCategory();
  }

  Future<void> fetchBooksByCategory() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('books')
              .where('category', isEqualTo: widget.categoryName)
              .get();

      setState(() {
        books = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading books: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(color: DevThemeConfig.devTextColor),
        ),
        backgroundColor: DevThemeConfig.devPrimaryColor,
        foregroundColor: DevThemeConfig.devTextColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: Container(
        color: DevThemeConfig.devBackgroundColor,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : books.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: books.length,
                    itemBuilder: (ctx, index) {
                      final book = books[index];
                      return CategoryProductCard(
                        book: book,
                        onAddToCart: (id, name, price) {
                          cartProvider.addItem(id, name, price, 1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name added to cart!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 80,
                          color: DevThemeConfig.devAccentColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No books found in this category',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: DevThemeConfig.devTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try exploring other categories or check back later.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: DevThemeConfig.devTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

// Category Product Card Widget
class CategoryProductCard extends StatelessWidget {
  final Map<String, dynamic> book;
  final void Function(String id, String name, double price) onAddToCart;

  const CategoryProductCard({
    super.key,
    required this.book,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final imageBase64 = book['image'] ?? '';
    Uint8List? imageBytes;
    if (imageBase64.isNotEmpty) {
      try {
        imageBytes = base64Decode(imageBase64);
      } catch (e) {
        print('Error decoding image: $e');
      }
    }

    final price = book['price'] ?? {};
    final amount = (price['amount'] ?? 0).toDouble();
    final currency = price['currency'] ?? 'USD';

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: imageBytes != null
                    ? Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.book, size: 40, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              book['title'] ?? 'Unnamed Book',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Author and Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Author: ${book['author'] ?? 'Unknown'}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  '$currency ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006400),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              book['description'] ?? 'No description available.',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            // Add to Cart Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    onAddToCart(
                      book['id'] ?? '',
                      book['title'] ?? 'Unnamed Book',
                      amount,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
