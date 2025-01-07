import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/widgets/address_screen.dart';
import 'package:myapp/widgets/my_details_screen.dart';
import 'package:myapp/widgets/theme_color.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File? _profileImage;
  String? _base64Image;
  String? _username;
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
        _username = _userData?['username'] ?? 'User';
        _base64Image = _userData?['profile_image'];
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final user = _auth.currentUser;
      if (user == null) return;

      _profileImage = File(pickedFile.path);
      _base64Image = base64Encode(await _profileImage!.readAsBytes());

      // Save the new image to Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'profile_image': _base64Image,
      });

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userData == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg01.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
                Column(
                  children: [
                    AppBar(
                      title: const Text('My Profile'),
                      centerTitle: true,
                      backgroundColor: Colors.transparent,
                      foregroundColor: DevThemeConfig.devTextColor,
                      elevation: 0,
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_base64Image != null
                                ? MemoryImage(base64Decode(_base64Image!))
                                : const AssetImage(
                                    'assets/images/default_user.png',
                                  )) as ImageProvider?,
                        child: _base64Image == null && _profileImage == null
                            ? const Icon(Icons.add_a_photo, size: 40)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _username ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    // const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildInfoTile(
                            'My Details',
                            () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyDetailsScreen(userData: _userData!),
                                ),
                              );
                              _fetchUserData(); // Refresh data after returning
                            },
                          ),
                          _buildInfoTile('My Orders', () {}),
                          _buildInfoTile('Cart', () {
                            Navigator.pushNamed(context, '/cart');
                          }),
                          _buildInfoTile('My Favorites', () {}),
                          _buildInfoTile('My Address', () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MakeAddressScreen(userData: _userData!),
                              ),
                            );
                            _fetchUserData(); // Refresh data after returning
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildInfoTile(String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
