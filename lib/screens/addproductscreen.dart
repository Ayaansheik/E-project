// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  bool _isNewDeal = false;
  bool _isTopSelling = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addProduct() async {
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final priceText = _priceController.text.trim();
    final image = _imageController.text.trim();
    final category = _categoryController.text.trim();
    final brand = _brandController.text.trim();

    if (name.isEmpty ||
        description.isEmpty ||
        priceText.isEmpty ||
        image.isEmpty ||
        category.isEmpty ||
        brand.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final price = double.parse(priceText);
      final productId = _firestore.collection('products').doc().id;

      await _firestore.collection('products').doc(productId).set({
        'id': productId,
        'name': name,
        'description': description,
        'price': price,
        'image': image,
        'category': category,
        'brand': brand,
        'isNewDeal': _isNewDeal,
        'isTopSelling': _isTopSelling,
      });

      _showSuccessDialog();
      _clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearFields() {
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _imageController.clear();
    _categoryController.clear();
    _brandController.clear();
    setState(() {
      _isNewDeal = false;
      _isTopSelling = false;
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Product added successfully!'),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close the dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add New Product",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.1),
                  hintText: "Name",
                  prefixIcon: const Icon(Icons.label, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.1),
                  hintText: "Description",
                  prefixIcon:
                      const Icon(Icons.description, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.1),
                  hintText: "Price",
                  prefixIcon:
                      const Icon(Icons.attach_money, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _imageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.1),
                  hintText: "Image URL",
                  prefixIcon: const Icon(Icons.image, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.1),
                  hintText: "Category",
                  prefixIcon: const Icon(Icons.category, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _brandController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.green.withOpacity(0.1),
                  hintText: "Brand",
                  prefixIcon:
                      const Icon(Icons.branding_watermark, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _isNewDeal,
                        onChanged: (value) {
                          setState(() {
                            _isNewDeal = value!;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      const Text('Is New Deal'),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isTopSelling,
                        onChanged: (value) {
                          setState(() {
                            _isTopSelling = value!;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                      const Text('Is Top Selling'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add Product',
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
