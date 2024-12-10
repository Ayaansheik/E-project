import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/food_item.dart';

class FoodCard extends StatelessWidget {
  final FoodItem foodItem;

  const FoodCard({super.key, required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/details', arguments: foodItem);
      },
      child: Card(
        elevation: 8, // Increased elevation for a more noticeable shadow
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: SizedBox(
          height: 120, // Fixed height for both image and card
          child: Row(
            children: [
              // Image Section
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
                child: CachedNetworkImage(
                  imageUrl: foodItem.image,
                  height: 120, // Fixed height for the image
                  width: 120, // Fixed width
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 110,
                    color: Colors.grey[300],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    return Container(
                      height: 110,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.white, size: 40),
                      ),
                    );
                  },
                ),
              ),
              // Content Section (Name, Price, Description)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food Name
                      Text(
                        foodItem.name,
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
                            '\$${foodItem.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF006400),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Description with overflow handling
                      Text(
                        foodItem.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 2, // Limit description to 2 lines
                        overflow: TextOverflow.ellipsis,
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
