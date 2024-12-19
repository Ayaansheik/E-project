import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  File? _profileImage;
  String? _base64Image;
  bool _isEditing = false;

  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docSnapshot =
        await _firestore.collection('users').doc(user.uid).get();
    if (docSnapshot.exists) {
      setState(() {
        _userData = docSnapshot.data();
        _usernameController.text = _userData?['username'] ?? '';
        _emailController.text = _userData?['email'] ?? '';
        _phoneController.text = _userData?['phone'] ?? '';
        final address = _userData?['address'] ?? {};
        _streetController.text = address['street'] ?? '';
        _cityController.text = address['city'] ?? '';
        _stateController.text = address['state'] ?? '';
        _countryController.text = address['country'] ?? '';
        _base64Image = _userData?['profile_image'];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _base64Image = base64Encode(await _profileImage!.readAsBytes());
    }
  }

  Future<void> _updateUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final updatedData = {
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'address': {
        'street': _streetController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'country': _countryController.text.trim(),
      },
      'profile_image': _base64Image,
    };

    await _firestore.collection('users').doc(user.uid).update(updatedData);

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully!')),
    );
  }

  void _navigateToChangePassword() {
    Navigator.pushNamed(context, '/change-password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: const Color(0xFF006400),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _updateUserData,
            ),
        ],
      ),
      body: _userData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: _isEditing ? _pickImage : null,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_base64Image != null
                                ? MemoryImage(base64Decode(_base64Image!))
                                : null) as ImageProvider?,
                        child: _base64Image == null && _profileImage == null
                            ? const Icon(Icons.add_a_photo, size: 40)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Username',
                    _usernameController,
                    isEditable: _isEditing,
                  ),
                  _buildTextField(
                    'Email',
                    _emailController,
                    isEditable: _isEditing,
                  ),
                  _buildTextField(
                    'Phone Number',
                    _phoneController,
                    isEditable: _isEditing,
                  ),
                  _buildTextField(
                    'Street',
                    _streetController,
                    isEditable: _isEditing,
                  ),
                  _buildTextField(
                    'City',
                    _cityController,
                    isEditable: _isEditing,
                  ),
                  _buildTextField(
                    'State',
                    _stateController,
                    isEditable: _isEditing,
                  ),
                  _buildTextField(
                    'Country',
                    _countryController,
                    isEditable: _isEditing,
                  ),
                  const SizedBox(height: 20),
                  if (!_isEditing)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  if (!_isEditing)
                    ElevatedButton(
                      onPressed: _navigateToChangePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Change Password'),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isEditable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        enabled: isEditable,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
