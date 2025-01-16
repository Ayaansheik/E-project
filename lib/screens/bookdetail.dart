import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:myapp/widgets/theme_color.dart';

class BookDetailScreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Map<String, dynamic>? authorDetails;
  List<Map<String, dynamic>> similarBooks = [];
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _fetchAuthorDetails(widget.book['author']);
    _fetchSimilarBooks();
  }

  Future<void> _fetchAuthorDetails(String? authorName) async {
    if (authorName == null) return;

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('authors')
          .where('name', isEqualTo: authorName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          authorDetails = querySnapshot.docs.first.data();
        });
      }
    } catch (e) {
      debugPrint('Error fetching author details: $e');
    }
  }

  Future<void> _fetchSimilarBooks() async {
    try {
      final firestore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> querySnapshot;

      // Attempt to fetch books by the same author
      if (widget.book['author'] != null) {
        querySnapshot = await firestore
            .collection('books')
            .where('author', isEqualTo: widget.book['author'])
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            similarBooks = querySnapshot.docs.map((doc) => doc.data()).toList();
          });
          return;
        }
      }

      // Attempt to fetch books in the same category
      if (widget.book['category'] != null) {
        querySnapshot = await firestore
            .collection('books')
            .where('category', isEqualTo: widget.book['category'])
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            similarBooks = querySnapshot.docs.map((doc) => doc.data()).toList();
          });
          return;
        }
      }

      // Fetch random books if no similar books found
      querySnapshot = await firestore.collection('books').limit(10).get();
      setState(() {
        similarBooks = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      debugPrint('Error fetching similar books: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final Uint8List? bookImageBytes = book['image'] != null
        ? base64Decode(book['image'].split(',').last)
        : null;

    final Uint8List? authorImageBytes = authorDetails?['profilePicture'] != null
        ? base64Decode(authorDetails!['profilePicture'].split(',').last)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(book['title'] ?? 'Book Details'),
        centerTitle: true,
        backgroundColor: DevThemeConfig.devPrimaryColor,
        foregroundColor: DevThemeConfig.devBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookImage(bookImageBytes),
            const SizedBox(height: 20),
            _buildBookTitleAndAuthor(book, authorImageBytes),
            const SizedBox(height: 20),
            _buildPriceSection(book),
            const SizedBox(height: 20),
            _buildQuantitySection(),
            const SizedBox(height: 20),
            _buildDescription(book['description']),
            const SizedBox(height: 20),
            if ((book['reviews'] ?? []).isNotEmpty)
              _buildReviewSection(book['reviews']),
            const SizedBox(height: 20),
            _buildSimilarBooksSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBookImage(Uint8List? imageBytes) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
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
    );
  }

  Widget _buildBookTitleAndAuthor(
      Map<String, dynamic> book, Uint8List? authorImageBytes) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage:
              authorImageBytes != null ? MemoryImage(authorImageBytes) : null,
          radius: 40,
          child: authorImageBytes == null
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
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'By ${book['author'] ?? 'Unknown Author'}',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection(Map<String, dynamic> book) {
    final price = book['price'] ?? {};
    final amount = (price['amount'] ?? 0).toDouble();
    final currency = price['currency'] ?? 'USD';

    return Text(
      '$currency ${amount.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
    );
  }

  Widget _buildQuantitySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (quantity > 1) {
                  setState(() {
                    quantity--;
                  });
                }
              },
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              quantity.toString(),
              style: const TextStyle(fontSize: 18),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  quantity++;
                });
              },
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {
                debugPrint("Added to Cart");
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: DevThemeConfig.devSecondaryColor,
                side: BorderSide(color: DevThemeConfig.devPrimaryColor),
              ),
              child: const Text('Add to Cart'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                debugPrint("Buy Now clicked");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DevThemeConfig.devPrimaryColor,
                foregroundColor: DevThemeConfig.devTextColor,
              ),
              child: const Text('Buy Now'),
            ),
          ],
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
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildReviewSection(List<dynamic> reviews) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return ListTile(
              title: Text(
                review['name'] ?? 'Anonymous',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(review['comment'] ?? ''),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSimilarBooksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Similar Books',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: similarBooks.length,
            itemBuilder: (context, index) {
              final book = similarBooks[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: book['image'] != null
                          ? Image.memory(
                              base64Decode(book['image'].split(',').last),
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.book,
                              size: 100,
                              color: Colors.grey,
                            ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      book['title'] ?? 'No Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
