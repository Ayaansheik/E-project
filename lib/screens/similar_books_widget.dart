import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SimilarBooksWidget extends StatefulWidget {
  final String? author;
  final String? category;

  const SimilarBooksWidget({Key? key, this.author, this.category})
      : super(key: key);

  @override
  State<SimilarBooksWidget> createState() => _SimilarBooksWidgetState();
}

class _SimilarBooksWidgetState extends State<SimilarBooksWidget> {
  List<Map<String, dynamic>> similarBooks = [];

  @override
  void initState() {
    super.initState();
    _fetchSimilarBooks();
  }

  Future<void> _fetchSimilarBooks() async {
    try {
      final firestore = FirebaseFirestore.instance;
      QuerySnapshot<Map<String, dynamic>> querySnapshot;

      // Fetch books by the same author
      if (widget.author != null) {
        querySnapshot = await firestore
            .collection('books')
            .where('author', isEqualTo: widget.author)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            similarBooks = querySnapshot.docs.map((doc) => doc.data()).toList();
          });
          return;
        }
      }

      // Fetch books in the same category
      if (widget.category != null) {
        querySnapshot = await firestore
            .collection('books')
            .where('category', isEqualTo: widget.category)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            similarBooks = querySnapshot.docs.map((doc) => doc.data()).toList();
          });
          return;
        }
      }

      // Fetch random books as fallback
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
          child: similarBooks.isNotEmpty
              ? ListView.builder(
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'By ${book['author'] ?? 'Unknown Author'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('No similar books available.'),
                ),
        ),
      ],
    );
  }
}
