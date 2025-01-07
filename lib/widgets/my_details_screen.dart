import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/theme_color.dart';

class MyDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const MyDetailsScreen({required this.userData, super.key});

  @override
  State<MyDetailsScreen> createState() => _MyDetailsScreenState();
}

class _MyDetailsScreenState extends State<MyDetailsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _usernameController.text = widget.userData['username'] ?? '';
    _emailController.text = widget.userData['email'] ?? '';
    _phoneController.text = widget.userData['phone'] ?? '';
  }

  Future<void> _updateDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'username': _usernameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Details updated successfully!')),
    );

    setState(() {
      _isEditing = false;
    });
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: !isEditing, // Disable editing unless in edit mode
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: DevThemeConfig.devPrimaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DevThemeConfig.devPrimaryColor),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Details'),
        backgroundColor: DevThemeConfig.devPrimaryColor,
        foregroundColor: DevThemeConfig.devTextColor,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateDetails();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              label: 'Username',
              controller: _usernameController,
              isEditing: _isEditing,
            ),
            _buildTextField(
              label: 'Email',
              controller: _emailController,
              isEditing: _isEditing,
            ),
            _buildTextField(
              label: 'Phone',
              controller: _phoneController,
              isEditing: _isEditing,
            ),
            const SizedBox(height: 20),
            if (_isEditing)
              ElevatedButton(
                onPressed: _updateDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DevThemeConfig.devPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Save'),
              ),
          ],
        ),
      ),
    );
  }
}
