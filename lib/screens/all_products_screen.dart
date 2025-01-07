import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/widgets/filter_widget.dart'; // Import the filter widget
import 'package:myapp/widgets/theme_color.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';
  double minPrice = 0;
  double maxPrice = double.infinity;
  bool showBestSellers = false;
  List<Map<String, dynamic>> books = [];
  List<String> categories = ['All'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as String?;
      if (args != null && args.isNotEmpty) {
        setState(() {
          searchQuery = args; // Initialize search query from arguments
        });
      }
      _fetchBooks();
    });
  }

  Future<void> _fetchBooks() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('books')
          .where('isVisible', isEqualTo: true)
          .get();

      setState(() {
        books = snapshot.docs.map((doc) => doc.data()).toList();
        categories = [
          'All',
          ...{...books.map((book) => book['category'] ?? 'Uncategorized')}
        ];
      });
    } catch (error) {
      print('Error fetching books: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load books')),
      );
    }
  }

  List<Map<String, dynamic>> _filteredBooks() {
    return books.where((book) {
      final title = book['title']?.toString().toLowerCase() ?? '';
      final author = book['author']?.toString().toLowerCase() ?? '';
      final category = book['category']?.toString() ?? 'Uncategorized';
      final price = (book['price'] ?? {'amount': 0})['amount']?.toDouble() ?? 0;
      final isTopSelling = book['isTopSelling'] ?? false;
      final query = searchQuery.toLowerCase();

      return (title.contains(query) || author.contains(query)) &&
          (selectedCategory == 'All' || category == selectedCategory) &&
          price >= minPrice &&
          price <= maxPrice &&
          (!showBestSellers || isTopSelling);
    }).toList();
  }

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
            setState(() {});
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _filteredBooks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        backgroundColor: DevThemeConfig.devPrimaryColor,
        foregroundColor: DevThemeConfig.devTextColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: searchQuery),
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
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
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
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = filteredBooks[index];
                        Uint8List? imageBytes;

                        try {
                          final imageBase64 = book['imageBase64'] ?? '';
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
                            // Navigate to book details
                          },
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                  child: imageBytes != null
                                      ? Image.memory(
                                          imageBytes,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(
                                          Icons.book,
                                          size: 120,
                                          color: Colors.grey,
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book['title'] ?? 'No Title',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Author: ${book['author'] ?? 'Unknown'}',
                                        style: const TextStyle(fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '$currency ${amount.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.teal,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
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
                      child: Text('No books match your search'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
