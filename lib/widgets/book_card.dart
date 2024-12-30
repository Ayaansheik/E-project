import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookCard extends StatelessWidget {
  final Map<String, dynamic> book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Add navigation or onTap functionality if needed
      child: Card(
        color: Colors.grey[200], // Default background color for debugging
        elevation: 8, // Increased elevation for a more noticeable shadow
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: SizedBox(
          height: 130, // Fixed height for the card
          child: Row(
            children: [
              // Image Section
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
                child: book['image'] != null
                    ? Image.memory(
                        base64Decode(book['image']),
                        height: 130, // Fixed height for the image
                        width: 130, // Fixed width
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 130,
                        width: 130,
                        color: Colors.grey[300],
                        child: const Center(
                          child:
                              Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                      ),
              ),
              // Content Section (Title, Price, Description)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book Title
                      Text(
                        book['title'] ?? 'Unknown Title',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      // Price Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${book['price']['amount']?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              color: Color(0xFF006400),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '${book['stock'] ?? 0} in stock',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Description with overflow handling
                      Flexible(
                        child: Text(
                          book['description'] ?? 'No description available.',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          maxLines: 2, // Limit description to 2 lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookListWidget extends StatelessWidget {
  const BookListWidget({super.key});

  // Fetch books from Firestore
  Future<List<Map<String, dynamic>>> _fetchBooks() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('books').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading books'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No books available'));
        }

        final books = snapshot.data!;

        // Use a Column instead of ListView.builder for non-scrollable cards
        return Column(
          children: books.map((book) {
            return BookCard(book: book); // Using the BookCard widget
          }).toList(),
        );
      },
    );
  }
}
