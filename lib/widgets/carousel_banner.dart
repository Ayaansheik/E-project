import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CarouselBanner extends StatelessWidget {
  final List<String> imageUrls;

  const CarouselBanner({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200, // Adjusted height for landscape images
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0, // Suitable for landscape
        viewportFraction: 0.92, // Increased width for each item
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(seconds: 2),
      ),
      items: imageUrls.map((assetPath) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(15), // Slightly smaller rounding
            child: Stack(
              fit: StackFit.expand,
              children: [
                // CachedNetworkImage background with cover fit
                CachedNetworkImage(
                  imageUrl: assetPath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child:
                        CircularProgressIndicator(), // Placeholder while loading
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error), // Error widget
                ),
                // Gradient overlay for a premium feel
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                    ),
                  ),
                ),
                // Positioned Text for "Featured"
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Featured',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
