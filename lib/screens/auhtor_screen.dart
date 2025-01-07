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
            return const Center(child: Text('Error fetching authors'));
          }

          final authors = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: authors.length,
            itemBuilder: (context, index) {
              final authorDoc = authors[index];
              final authorData = authorDoc.data() as Map<String, dynamic>;

              return InkWell(
                onTap: () {
                  final authorId = authorDoc.id;
                  print(
                      'Navigating to AuthorDetailScreen with authorId: $authorId');
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
                  isFamous: authorData['isFamous'] ?? false,
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
  final bool isFamous;

  const AuthorCard({
    super.key,
    required this.name,
    required this.bio,
    required this.nationality,
    required this.profilePicture,
    required this.isFamous,
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
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundImage: profilePicture.isNotEmpty
                  ? MemoryImage(base64Decode(profilePicture))
                  : null,
              child: profilePicture.isEmpty
                  ? Icon(Icons.person, size: 40, color: Colors.grey)
                  : null,
            ),
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
                    maxLines: 1,
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
}
