import 'dart:convert'; // For base64 decoding
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firebase Firestore
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({super.key});

  @override
  CarouselBannerState createState() => CarouselBannerState();
}

class CarouselBannerState extends State<CarouselBanner> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> bannerData =
      []; // List to store banner data (image, isFeatured)
  bool isLoading = true; // Flag to show loading spinner

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  // Fetch images from Firestore
  Future<void> _fetchImages() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('banners') // Your Firestore collection
          .where('isVisible', isEqualTo: true) // Only visible banners
          .get();

      // Fetch Base64 encoded images and isFeatured field from Firestore
      List<Map<String, dynamic>> fetchedBanners = snapshot.docs
          .map((doc) => {
                'image': doc['image'] as String, // Base64 string
                'isFeatured': doc['isFeatured'] as bool, // Boolean value
              })
          .toList();

      // Update state
      setState(() {
        bannerData = fetchedBanners;
        isLoading = false; // Set loading to false once images are fetched
      });
    } catch (error) {
      setState(() {
        isLoading = false; // Set loading to false if an error occurs
      });
      debugPrint('Error fetching images: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching images
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Carousel Slider to display images
    return CarouselSlider(
      options: CarouselOptions(
        height: 200, // Adjusted height for landscape images
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 2.0, // Suitable for landscape images
        viewportFraction: 0.92, // Adjust the width of each item
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(seconds: 2),
      ),
      items: bannerData.map((banner) {
        // Clean Base64 string to remove any metadata (e.g., "data:image/jpeg;base64,")
        String cleanBase64String = banner['image']
            .replaceFirst(RegExp(r"^data:image\/[a-zA-Z]*;base64,"), "");

        // Decode Base64 string into bytes
        Uint8List bytes = base64Decode(cleanBase64String);

        // Inside the carousel item mapping
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Display the decoded image from Base64 bytes
                Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error), // Show error icon if image fails
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
                // Show "Featured" only if the banner is featured
                if (banner['isFeatured'] == true)
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        // color: Colors.black.withOpacity(0.5),
                        color: Colors.black.withOpacity(0.6),
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
