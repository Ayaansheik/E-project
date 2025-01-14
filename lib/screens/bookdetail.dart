import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) quantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final price = book['price'] ?? {};
    final amount = (price['amount'] ?? 0).toDouble(); // Ensure amount is a double
    final currency = price['currency'] ?? 'USD';
    final imageBase64 = book['image'] ?? '';
    final imageBytes =
        imageBase64.isNotEmpty ? base64Decode(imageBase64.split(',').last) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? 'Book Details'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCard(imageBytes, book),
            const SizedBox(height: 20),
            _buildQuantitySelector(),
            const SizedBox(height: 20),
            _buildPriceSection(amount, currency, price),
            const SizedBox(height: 20),
            _buildBookDetails(book),
            const SizedBox(height: 20),
            _buildDescription(book['description']),
            const SizedBox(height: 20),
            _buildRelatedBooksSection(book['author'], book['relatedBooks']),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(Uint8List? imageBytes, Map<String, dynamic> book) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: imageBytes != null
                ? Image.memory(
                    imageBytes,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.book,
                    size: 150,
                    color: Colors.grey,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      imageBytes != null ? MemoryImage(imageBytes) : null,
                  radius: 40,
                  child: imageBytes == null
                      ? const Icon(Icons.person, size: 40)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'] ?? 'No Title',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By ${book['author'] ?? 'Unknown'}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: decrementQuantity,
        ),
        Text(
          '$quantity',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: incrementQuantity,
        ),
      ],
    );
  }

  Widget _buildPriceSection(double amount, String currency, Map price) {
    final originalPrice = (price['original'] ?? amount).toDouble();
    final discountPercentage = price['discount'] ?? 0;

    // Calculate prices based on the quantity
    final totalOriginalPrice = originalPrice * quantity;
    final discountAmount = totalOriginalPrice * (discountPercentage / 100);
    final totalDiscountedPrice = totalOriginalPrice - discountAmount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Details:',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Original Price:',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Text(
              '$currency ${totalOriginalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Discount ($discountPercentage%):',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            Text(
              '- $currency ${discountAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Final Price:',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
            Text(
              '$currency ${totalDiscountedPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D47A1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              debugPrint("Buy Now clicked");
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Buy Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D47A1),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookDetails(Map<String, dynamic> book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Book Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Category: ${book['category'] ?? 'N/A'}\n'
          'Publisher: ${book['publisher'] ?? 'N/A'}\n'
          'Number of Pages: ${book['pages'] ?? 'N/A'}\n'
          'Rating: ${book['ratings']?['average'] ?? 'N/A'}\n'
          'ISBN: ${book['isbn'] ?? 'N/A'}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildDescription(String? description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          description ?? 'No description available.',
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildRelatedBooksSection(String? author, List? relatedBooks) {
    if (relatedBooks == null || relatedBooks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          'No other books by ${author ?? 'this author'} available.',
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More Books by ${author ?? 'Author'}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: relatedBooks.length,
            itemBuilder: (context, index) {
              final book = relatedBooks[index] ?? {};
              return _buildRelatedBookCard(book);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRelatedBookCard(Map book) {
    final imageUrl = book["image"] ?? '';
    final title = book["title"] ?? 'N/A';
    final price = (book["price"]?['amount'] ?? 0).toDouble();
    final currency = book["price"]?['currency'] ?? 'USD';

    return Card(
      elevation: 5,
      margin: const EdgeInsets.only(right: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: imageUrl.isNotEmpty
                ? Image.memory(
                    base64Decode(book["image"].split(',').last),
                    height: 100,
                    width: 130,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image,
                      size: 100,
                      color: Colors.grey,
                    ),
                  )
                : const Icon(
                    Icons.image,
                    size: 100,
                    color: Colors.grey,
                  ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$currency ${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
        ],
      ),
    );
  }
}
