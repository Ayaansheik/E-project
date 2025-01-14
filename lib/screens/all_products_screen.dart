import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/widgets/filter_widget.dart'; // Import the filter widget
import 'package:myapp/widgets/theme_color.dart';
import 'package:myapp/screens/bookdetail.dart'; // Import the BookDetailScreen

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  String searchQuery = ''; // Store the search query
  String selectedCategory = 'All'; // Selected category filter
  double minPrice = 0; // Minimum price filter
  double maxPrice = double.infinity; // Maximum price filter
  bool showBestSellers = false; // Filter for best sellers
  List<Map<String, dynamic>> books = []; // List to store books
  List<String> categories = ['All']; // List of categories

  @override
  void initState() {
    super.initState();
    _fetchBooks(); // Fetch books from Firestore when the screen is initialized
  }

  Future<void> _fetchBooks() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('books')
          .where('isVisible', isEqualTo: true) // Only fetch visible books
          .get();

      setState(() {
        books =
            snapshot.docs.map((doc) => doc.data()).toList(); // Set books data
        categories = [
          'All',
          ...{
            ...books.map((book) => book['category'] ?? 'Uncategorized')
          } // Populate categories
        ];
      });
    } catch (error) {
      print('Error fetching books: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load books')),
      );
    }
  }

  // Filters the books based on title, author, category, price, and best-sellers
  List<Map<String, dynamic>> _filteredBooks() {
    return books.where((book) {
      final title = book['title']?.toString().toLowerCase() ?? '';
      final author = book['author']?.toString().toLowerCase() ?? '';
      final category = book['category']?.toString() ?? 'Uncategorized';
      final price = (book['price'] ?? {'amount': 0})['amount']?.toDouble() ?? 0;
      final isTopSelling = book['isTopSelling'] ?? false;
      final query = searchQuery.toLowerCase();

      // Check if the title or author contains the search query
      final matchesSearch = title.contains(query) || author.contains(query);

      // Return books that match search query and apply other filters (category, price, best-sellers)
      return matchesSearch &&
          (selectedCategory == 'All' || category == selectedCategory) &&
          price >= minPrice &&
          price <= maxPrice &&
          (!showBestSellers || isTopSelling);
    }).toList();
  }

  // Opens the filter dialog
  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterWidget(
          selectedCategory: selectedCategory,
          categories: categories,
          minPrice: minPrice,
          maxPrice: maxPrice,
          showBestSellers: showBestSellers,
          onCategoryChanged: (value) {
            setState(() {
              selectedCategory = value ?? 'All';
            });
          },
          onMinPriceChanged: (value) {
            setState(() {
              minPrice = value;
            });
          },
          onMaxPriceChanged: (value) {
            setState(() {
              maxPrice = value;
            });
          },
          onBestSellersChanged: (value) {
            setState(() {
              showBestSellers = value ?? false;
            });
          },
          onApplyFilters: () {
            setState(() {}); // Apply filters
            Navigator.pop(context); // Close the filter dialog
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks =
        _filteredBooks(); // Get the filtered books based on search query and filters

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        backgroundColor: DevThemeConfig.devPrimaryColor,
        foregroundColor: DevThemeConfig.devTextColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterDialog, // Open filter dialog
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Search TextField
            TextField(
              decoration: InputDecoration(
                labelText: 'Search by title or author',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchQuery = ''; // Clear search query
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update search query as the user types
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredBooks.isNotEmpty
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        Uint8List? imageBytes;

                        // Decode base64 image if available
                        try {
                          final imageBase64 = book['image'] ?? '';
                          if (imageBase64.isNotEmpty) {
                            imageBytes = base64Decode(imageBase64);
                          }
                        } catch (e) {
                          print(
                              'Error decoding image for book "${book['title']}": $e');
                        }

                        final price = book['price'] ?? {};
                        final amount = price['amount'] ?? 0;
                        final currency = price['currency'] ?? 'USD';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailScreen(
                                    book: book), // Navigate to book details
                              ),
                            );
                          },
                          child: Card(
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
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.contain,
                                        )
                                      : const Icon(
                                          Icons.book,
                                          size: 120,
                                          color: Colors.grey,
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.grey[200],
                                        radius: 20,
                                        child: const Icon(Icons.person),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              book['title'] ?? 'No Title',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              'By ${book['author'] ?? 'Unknown'}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '$currency ${amount.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0D47A1),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                          Text(
                                            (book['rating'] ?? 0).toString(),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                          'No books match your search'), // No books found message
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
