import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _pagesController = TextEditingController();

  File? _image; // Holds selected image
  String? _selectedCategory;
  String? _selectedAuthor;
  DateTime? _publicationDate;

  // Categories and Authors list (to be fetched from Firestore)
  List<String> _categories = [];
  List<String> _authors = [];

  bool _isTopSelling = false;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _fetchCategoriesAndAuthors();
  }

  // Fetch categories and authors from Firestore
  Future<void> _fetchCategoriesAndAuthors() async {
    try {
      // Fetch categories
      var categoriesSnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        _categories = categoriesSnapshot.docs
            .map((doc) => doc['name'] as String)
            .toList();
      });

      // Fetch authors
      var authorsSnapshot =
          await FirebaseFirestore.instance.collection('authors').get();
      setState(() {
        _authors =
            authorsSnapshot.docs.map((doc) => doc['name'] as String).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
    }
  }

  // Function to pick an image and convert it to base64
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Pick publication date
  Future<void> _pickPublicationDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _publicationDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _publicationDate) {
      setState(() {
        _publicationDate = picked;
      });
    }
  }

  // Save book data to Firestore
  Future<void> _saveBookToFirestore() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null ||
          _selectedAuthor == null ||
          _image == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please fill all fields')));
        return;
      }

      try {
        String base64Image = base64Encode(_image!.readAsBytesSync());

        await FirebaseFirestore.instance.collection('books').add({
          'title': _titleController.text,
          'author': _selectedAuthor, // Store author name as text
          'category': _selectedCategory, // Store category name as text
          'price': {
            'amount': double.tryParse(_priceController.text) ?? 0.0,
            'currency': 'USD' // You can make this dynamic if needed
          },
          'description': _descriptionController.text,
          'isbn': _isbnController.text,
          'isTopSelling': _isTopSelling,
          'isVisible': _isVisible,
          'language': _languageController.text,
          'pages': int.tryParse(_pagesController.text) ?? 0,
          'publicationDate': _publicationDate != null
              ? Timestamp.fromDate(
                  _publicationDate!) // Store the publication date
              : FieldValue.serverTimestamp(),
          'publisher': _publisherController.text,
          'ratings': {
            'average': 4.5, // Replace with actual logic to calculate average
            'count': 100, // Replace with actual count logic
          },
          'stock': int.tryParse(_stockController.text) ?? 0,
          'image': base64Image,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Book added successfully!')));

        // Clear the form
        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to add book: $e')));
      }
    }
  }

  // Clear form fields
  void _clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _isbnController.clear();
    _languageController.clear();
    _publisherController.clear();
    _stockController.clear();
    _pagesController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedAuthor = null;
      _image = null;
      _publicationDate = null;
      _isTopSelling = false;
      _isVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Book Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the book title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Author Dropdown (store selected author name directly)
                DropdownButtonFormField<String>(
                  value: _selectedAuthor,
                  items: _authors.map((author) {
                    return DropdownMenuItem(
                      value: author,
                      child: Text(author),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAuthor = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Author'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select an author';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Category Dropdown (store selected category name directly)
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Price
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                SizedBox(height: 16.0),

                // ISBN
                TextFormField(
                  controller: _isbnController,
                  decoration: InputDecoration(labelText: 'ISBN'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ISBN';
                    }
                    // Check if the ISBN is exactly 13 digits long and contains only numbers
                    if (value.length != 13 || int.tryParse(value) == null) {
                      return 'ISBN must be a 13-digit number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),

                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: _image == null
                        ? Text('Tap to select an image')
                        : Image.file(_image!),
                  ),
                ),
                SizedBox(height: 16.0),

                // Publication Date Picker
                GestureDetector(
                  onTap: _pickPublicationDate,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: _publicationDate == null
                        ? Text('Pick Publication Date')
                        : Text(
                            'Publication Date: ${_publicationDate!.toLocal()}'),
                  ),
                ),
                SizedBox(height: 16.0),

                // Additional Fields (like Language, Pages, etc.)
                TextFormField(
                    controller: _languageController,
                    decoration: InputDecoration(labelText: 'Language')),
                TextFormField(
                    controller: _pagesController,
                    decoration: InputDecoration(labelText: 'Pages')),
                TextFormField(
                    controller: _publisherController,
                    decoration: InputDecoration(labelText: 'Publisher')),
                TextFormField(
                    controller: _stockController,
                    decoration: InputDecoration(labelText: 'Stock')),

                SizedBox(height: 16.0),

                // Top Selling Checkbox
                CheckboxListTile(
                  title: Text("Is Top Selling?"),
                  value: _isTopSelling,
                  onChanged: (bool? value) {
                    setState(() {
                      _isTopSelling = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 16.0),

                // Visible Checkbox
                CheckboxListTile(
                  title: Text("Is Visible?"),
                  value: _isVisible,
                  onChanged: (bool? value) {
                    setState(() {
                      _isVisible = value ?? true;
                    });
                  },
                ),

                SizedBox(height: 32.0),

                ElevatedButton(
                  onPressed: _saveBookToFirestore,
                  child: Text('Add Book'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
