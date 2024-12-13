import 'dart:convert'; // For base64 encoding
import 'dart:io'; // For picking images and file handling
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // To pick images

class InsertCategoryScreen extends StatefulWidget {
  const InsertCategoryScreen({super.key});

  @override
  InsertCategoryScreenState createState() => InsertCategoryScreenState();
}

class InsertCategoryScreenState extends State<InsertCategoryScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image; // To store selected image file
  bool _isLoading = false; // To track loading state
  String _categoryName = ""; // To store category name
  bool _isVisible = true; // To track visibility of the category

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to pick an image from gallery or camera
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Method to convert image to Base64 and upload to Firestore
  Future<void> _uploadCategory() async {
    if (_image == null || _categoryName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select an image and enter a name.')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Read image bytes
      final bytes = await _image!.readAsBytes();
      // Convert bytes to Base64 string
      String base64Image = base64Encode(bytes);

      // Insert into Firestore
      await _firestore.collection('categories').add({
        'name': _categoryName, // Category name
        'image': base64Image, // Base64 encoded image
        'isVisible': _isVisible, // Visibility status
        'createdAt': Timestamp.now(), // Timestamp for when it was added
      });

      setState(() {
        _isLoading = false; // Stop loading
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category uploaded successfully!')),
      );
      // Optionally clear the image and name
      setState(() {
        _image = null;
        _categoryName = "";
      });
    } catch (error) {
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error uploading category.')),
      );
      print('Error uploading category: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image display section
            GestureDetector(
              onTap: _pickImage, // Tap to pick an image
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _image == null
                    ? const Center(child: Icon(Icons.add_a_photo, size: 40))
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // Category name input
            TextField(
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _categoryName = value;
                });
              },
            ),
            const SizedBox(height: 20),

            // Visibility switch
            Row(
              children: [
                const Text('Is Visible:'),
                Switch(
                  value: _isVisible,
                  onChanged: (value) {
                    setState(() {
                      _isVisible = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Upload Button
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _uploadCategory,
                    child: const Text('Upload Category'),
                  ),
          ],
        ),
      ),
    );
  }
}
