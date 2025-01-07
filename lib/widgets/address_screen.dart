import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/theme_color.dart';

class MakeAddressScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const MakeAddressScreen({required this.userData, super.key});

  @override
  _MakeAddressScreenState createState() => _MakeAddressScreenState();
}

class _MakeAddressScreenState extends State<MakeAddressScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final address = widget.userData['address'] ?? {};
    _cityController.text = address['city'] ?? '';
    _stateController.text = address['state'] ?? '';
    _countryController.text = address['country'] ?? '';
    _streetController.text = address['street'] ?? '';
  }

  Future<void> _updateAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final updatedAddress = {
      'city': _cityController.text,
      'state': _stateController.text,
      'country': _countryController.text,
      'street': _streetController.text,
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'address': updatedAddress});

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address updated successfully!')),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      readOnly: !_isEditing, // Disable editing if not in edit mode
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: DevThemeConfig.devPrimaryColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: DevThemeConfig.devPrimaryColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Address'),
        backgroundColor: DevThemeConfig.devPrimaryColor,
        foregroundColor: DevThemeConfig.devTextColor,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _updateAddress();
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
            _buildTextField(label: 'City', controller: _cityController),
            const SizedBox(height: 16),
            _buildTextField(label: 'State', controller: _stateController),
            const SizedBox(height: 16),
            _buildTextField(label: 'Country', controller: _countryController),
            const SizedBox(height: 16),
            _buildTextField(label: 'Street', controller: _streetController),
            const SizedBox(height: 16),
            if (_isEditing)
              ElevatedButton(
                onPressed: _updateAddress,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DevThemeConfig.devPrimaryColor,
                  foregroundColor: DevThemeConfig.devTextColor,
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
