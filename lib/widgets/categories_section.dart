import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:myapp/screens/categoryproducts_screen.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  CategoryGridState createState() => CategoryGridState();
}

class CategoryGridState extends State<CategoryGrid> {
  // Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<Category>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = fetchCategories();
  }

  // Fetch categories from Firestore
  Future<List<Category>> fetchCategories() async {
    QuerySnapshot snapshot =
        await _firestore.collection('categories').limit(8).get();
    return snapshot.docs.map((doc) {
      return Category(
        name: doc['name'] ?? '',
        iconBase64: doc['image'] ?? '',
        isVisible: doc['isVisible'] ?? true,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading categories.'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found.'));
        } else {
          var categories = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return category.isVisible
                    ? GestureDetector(
                        onTap: () {
                          // Navigate to CategoryProductsScreen with the category name
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => categoryproductsscreen(
                                categoryName: category.name,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.memory(
                                  base64Decode(category.iconBase64),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(); // If not visible, return an empty container
              },
            ),
          );
        }
      },
    );
  }
}

// Category model to hold the data
class Category {
  final String name;
  final String iconBase64;
  final bool isVisible;

  Category({
    required this.name,
    required this.iconBase64,
    required this.isVisible,
  });
}
