import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import for caching
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';

class FoodDetailScreen extends StatefulWidget {
  const FoodDetailScreen({super.key});

  @override
  FoodDetailScreenState createState() => FoodDetailScreenState();
}

class FoodDetailScreenState extends State<FoodDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final FoodItem foodItem =
        ModalRoute.of(context)!.settings.arguments as FoodItem;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          foodItem.name,
          style: TextStyle(
            color: Theme.of(context)
                .hintColor, // Use hintColor from the app's theme
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use CachedNetworkImage for image loading with caching
            if (foodItem.image.isNotEmpty)
              CachedNetworkImage(
                imageUrl: foodItem.image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, size: 100),
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
              )
            else
              // Fallback image if no URL is available
              Image.network(
                foodItem.image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error, size: 100),
              ),

            const SizedBox(height: 20),

            // Food Name and Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Offered by: ${foodItem.brand}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    foodItem.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Price and Quantity Selector with Add to Cart Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Price: \$${(foodItem.price * quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (quantity > 1) quantity--;
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            quantity.toString(),
                            style: const TextStyle(fontSize: 20),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                quantity++;
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: () {
                      cartProvider.addItem(foodItem.id, foodItem.name,
                          foodItem.price, quantity); // Pass quantity
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${foodItem.name} added to cart!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Add to Cart'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Reviews Section with Star Ratings
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Reviews',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    title: Text('John Doe'),
                    subtitle: Text('Great taste, really enjoyed it!'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star_half, color: Colors.amber),
                        Icon(Icons.star_border, color: Colors.grey),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Text('Jane Smith'),
                    subtitle: Text('A bit pricey, but delicious.'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star, color: Colors.amber),
                        Icon(Icons.star_border, color: Colors.grey),
                      ],
                    ),
                  ),
                  // Add more reviews here as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
