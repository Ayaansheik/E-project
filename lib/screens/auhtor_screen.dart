import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/widgets/theme_color.dart';

class AuthorScreen extends StatelessWidget {
  final CollectionReference authorsRef =
      FirebaseFirestore.instance.collection('authors');

  AuthorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Authors',
          style: TextStyle(color: DevThemeConfig.devTextColor),
        ),
        backgroundColor: DevThemeConfig.devPrimaryColor,
        iconTheme: IconThemeData(color: DevThemeConfig.devTextColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: authorsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error fetching authors. Please try again later.',
                style: TextStyle(fontSize: 16, color: Colors.red),
              ),
            );
          }

          final authors = snapshot.data?.docs ?? [];

          if (authors.isEmpty) {
            return const Center(
              child: Text(
                'No authors available.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: authors.length,
            itemBuilder: (context, index) {
              final authorDoc = authors[index];
              final authorData = authorDoc.data() as Map<String, dynamic>;

              return InkWell(
                onTap: () {
                  final authorId = authorDoc.id;
                  Navigator.pushNamed(
                    context,
                    '/authorDetails',
                    arguments: authorId,
                  );
                },
                child: AuthorCard(
                  name: authorData['name'] ?? 'Unknown',
                  bio: authorData['bio'] ?? 'No bio available',
                  nationality: authorData['nationality'] ?? 'Unknown',
                  profilePicture: authorData['profilePicture'] ?? '',
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AuthorCard extends StatelessWidget {
  final String name;
  final String bio;
  final String nationality;
  final String profilePicture;

  const AuthorCard({
    super.key,
    required this.name,
    required this.bio,
    required this.nationality,
    required this.profilePicture,
  });

  String _truncateBio(String bio) {
    const int maxLength = 40;
    if (bio.length > maxLength) {
      return '${bio.substring(0, maxLength)}...';
    }
    return bio;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _decodeBase64Image(profilePicture, size: 80.0),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: DevThemeConfig.devPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Nationality: $nationality',
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _truncateBio(bio),
                    style: const TextStyle(fontSize: 14.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decodeBase64Image(String base64String, {double size = 80.0}) {
    try {
      // Check if the string contains a data URI scheme and strip it
      final base64Data = base64String.contains(',')
          ? base64String.split(',')[1]
          : base64String;

      if (base64Data.isNotEmpty) {
        return CircleAvatar(
          radius: size / 2,
          backgroundImage: MemoryImage(base64Decode(base64Data)),
        );
      }
    } catch (e) {
      // Optionally, log the error for debugging
      debugPrint('Error decoding Base64 image: $e');
    }
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.grey[300],
      child: const Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }
}
