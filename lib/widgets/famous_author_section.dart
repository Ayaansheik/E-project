import 'dart:convert'; // For base64 decoding
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthorSection extends StatelessWidget {
  const AuthorSection({super.key});

  Future<List<Map<String, dynamic>>> _fetchAuthors() async {
    // Fetch authors where isVisible is true
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('authors')
        .where('isVisible', isEqualTo: true)
        .get();

    // Convert query results to a list of maps
    return querySnapshot.docs
        .map((doc) => {
              'name': doc['name'] ?? '',
              'profilePicture': doc['profilePicture'] ?? '',
              'isFamous': doc['isFamous'] ?? false,
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Famous Authors",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // FutureBuilder to load authors
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchAuthors(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading authors'));
              }

              final authors = snapshot.data ?? [];

              // Filter famous authors
              final famousAuthors = authors
                  .where((author) => author['isFamous'] == true)
                  .toList();

              if (famousAuthors.isEmpty) {
                return const Center(child: Text('No famous authors found.'));
              }

              return SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: famousAuthors.length,
                  itemBuilder: (context, index) {
                    final author = famousAuthors[index];
                    final imageBytes = base64Decode(author['profilePicture']);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Author image with gradient and rounded borders
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFe0f7fa),
                                  Color(0xFFb2ebf2),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.memory(
                                imageBytes,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Author name label
                          const SizedBox(height: 8),
                          Text(
                            author['name'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
