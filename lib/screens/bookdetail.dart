import 'dart:convert';
import 'package:flutter/material.dart';

class BookDetailScreen extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final price = book['price'] ?? {};
    final amount = price['amount'] ?? 0;
    final currency = price['currency'] ?? 'USD';
    final imageBase64 = book['imageBase64'] ?? '';
    final imageBytes =
        imageBase64.isNotEmpty ? base64Decode(imageBase64) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? 'Book Details'),
        backgroundColor: Colors.blue, // You can change this color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            imageBytes != null
                ? Image.memory(
                    imageBytes,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  )
                : const Icon(
                    Icons.book,
                    size: 150,
                    color: Colors.grey,
                  ),
            const SizedBox(height: 16),
            Text(
              book['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'By ${book['author'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 18, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$currency ${amount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              book['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
