// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../models/food_item.dart'; // Assuming the FoodItem model is imported
import '../services/mock_data.dart'; // Mock data for the food items

// ignore: camel_case_types
class categoryproductsscreen extends StatefulWidget {
  final String categoryName;

  const categoryproductsscreen({super.key, required this.categoryName});

  @override
  CategoryProductsScreenState createState() => CategoryProductsScreenState();
}

class CategoryProductsScreenState extends State<categoryproductsscreen> {
  late List<FoodItem> categoryItems;

  @override
  void initState() {
    super.initState();
    // Filter the mock data based on the category
    categoryItems = mockFoodItems
        .where((item) => item.category == widget.categoryName)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Color(0xFFFFD700), // Gold color for text
          ),
        ),
        backgroundColor:
            const Color(0xFF006400), // Dark Green color for AppBar background
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFFFFD700)),
            onPressed: () {
              // Navigate to the cart page
            },
          ),
        ],
      ),
      body: categoryItems.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: categoryItems.length,
              itemBuilder: (ctx, index) {
                final foodItem = categoryItems[index];
                return GestureDetector(
                  onTap: () {
                    // Navigate to the product details screen
                    Navigator.of(context)
                        .pushNamed('/details', arguments: foodItem);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black.withOpacity(0.25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: foodItem.image.isNotEmpty
                                  ? Image.network(
                                      foodItem.image,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.error),
                            ),
                            if (foodItem
                                .isNewDeal) // Show 'New Deals' label if applicable
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF006400),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'New Deal!',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            foodItem.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            '\$${foodItem.price}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Brand: ${foodItem.brand}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text('No products in this category')),
    );
  }
}
