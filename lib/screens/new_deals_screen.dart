// new_deals_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../services/mock_data.dart';

class NewDealsScreen extends StatelessWidget {
  const NewDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newDeals = mockFoodItems.where((item) => item.isNewDeal).toList();
    // ignore: unused_local_variable
    const Color premiumGreen = Color(0xFF006400); // Dark green theme color

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Deals",
          style: TextStyle(
            color: Theme.of(context)
                .hintColor, // Use hintColor from the app's theme
            // fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Color(0xFFFFD700), // Gold color
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView.builder(
          itemCount: newDeals.length,
          itemBuilder: (context, index) {
            final foodItem = newDeals[index];
            return NewDealCard(foodItem: foodItem);
          },
        ),
      ),
    );
  }
}

// New Deal Card with Add to Cart functionality
class NewDealCard extends StatelessWidget {
  final FoodItem foodItem;

  const NewDealCard({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

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
            // Image Placeholder with Rounded Corners
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: foodItem.image, // The URL of the image
                  fit: BoxFit
                      .cover, // To maintain aspect ratio and fill the space
                  errorWidget: (context, url, error) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.white, size: 40),
                      ),
                    );
                  },
                  placeholder: (context, url) => const Center(
                    child:
                        CircularProgressIndicator(), // Placeholder while image is loading
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Headline
            Text(
              foodItem.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),

            // Row for Subheading (Brand) and Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Subheading (Brand)
                Text(
                  foodItem.brand,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                // Price
                Text(
                  '\$${foodItem.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF006400),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Body text / Description
            Text(
              foodItem.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),

            // Buttons Section
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    cartProvider.addItem(
                      foodItem.id,
                      foodItem.name,
                      foodItem.price,
                      1, // Default quantity as 1
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${foodItem.name} added to cart!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'This feature is not available yet. The app is currently under development.',
                          style: TextStyle(fontSize: 16),
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    'Order Now',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
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
