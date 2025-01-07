import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

import 'package:myapp/widgets/theme_color.dart';

class AuthorDetailScreen extends StatefulWidget {
  const AuthorDetailScreen({super.key});

  @override
  AuthorDetailScreenState createState() => AuthorDetailScreenState();
}

class AuthorDetailScreenState extends State<AuthorDetailScreen> {
  Map<String, dynamic>? authorData;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchAuthorData());
  }

  Future<void> fetchAuthorData() async {
    final authorId = ModalRoute.of(context)?.settings.arguments as String?;

    if (authorId == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid author ID.")),
      );
      return;
    }

    try {
      // Fetch author details from Firestore
      DocumentSnapshot authorSnapshot = await FirebaseFirestore.instance
          .collection('authors')
          .doc(authorId)
          .get();

      if (authorSnapshot.exists) {
        setState(() {
          authorData = authorSnapshot.data() as Map<String, dynamic>?;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Author not found.")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching data: $e")),
      );
    }
  }

  Widget decodeBase64Image(String? base64String,
      {double width = 100, double height = 100}) {
    try {
      if (base64String != null && base64String.isNotEmpty) {
        return Image.memory(
          base64Decode(base64String),
          width: width,
          height: height,
          fit: BoxFit.cover,
        );
      }
    } catch (e) {
      print("Error decoding image: $e");
    }
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.image, size: width / 2, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final authorId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Author Details"),
        backgroundColor: DevThemeConfig.devPrimaryColor,
        foregroundColor: DevThemeConfig.devTextColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : authorData == null
              ? const Center(
                  child: Text(
                    "No author details found.",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      Container(
                        color: DevThemeConfig.devTextColor,
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: decodeBase64Image(
                                authorData?['profilePicture'],
                                width: 120,
                                height: 120,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authorData?['name'] ?? "Unknown",
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: DevThemeConfig.devPrimaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.flag, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        authorData?['nationality'] ?? "N/A",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Born: ${authorData?['dateOfBirth'] ?? 'Unknown'}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Biography Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Biography",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              authorData?['bio'] ?? "No biography available.",
                              style: const TextStyle(fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                      // Divider
                      const Divider(thickness: 1),
                      // Books Section
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: const Text(
                          "Books",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      authorData?['books'] != null
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Show 3 images in a row
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: 2 / 3, // Image aspect ratio
                              ),
                              itemCount: (authorData?['books'] as List).length,
                              itemBuilder: (context, index) {
                                var book = authorData?['books'][index];
                                return Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: decodeBase64Image(
                                        book['coverImage'],
                                        width: 100,
                                        height: 120,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      book['title'] ?? "No Title",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                );
                              },
                            )
                          : const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "No books available.",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                    ],
                  ),
                ),
    );
  }
}
