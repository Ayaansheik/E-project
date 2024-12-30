import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:myapp/widgets/theme_color.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _profileImage;

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();
    final phone = _phoneController.text.trim();

    if (email.isEmpty ||
        password.isEmpty ||
        username.isEmpty ||
        phone.isEmpty) {
      _showSnackbar("Please fill in all fields");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        String? base64ProfileImage;
        if (_profileImage != null) {
          final bytes = await _profileImage!.readAsBytes();
          base64ProfileImage = base64Encode(bytes);
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': email,
          'username': username,
          'phone': phone,
          'address': {
            'city': null,
            'street': null,
            'state': null,
            'country': null,
          },
          'profile_image': base64ProfileImage ?? '',
          'payment_method': null,
        });

        _emailController.clear();
        _passwordController.clear();
        _usernameController.clear();
        _phoneController.clear();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showSnackbar("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        _showSnackbar("The account already exists for that email.");
      } else {
        _showSnackbar(e.message ?? "Registration failed.");
      }
    } catch (e) {
      _showSnackbar("An error occurred. Please try again.");
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: DevThemeConfig.devPrimaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Fixed background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg01.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Blurred frosted glass effect
          // Positioned.fill(
          //   child: BackdropFilter(
          //     filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          //     child: Container(
          //       color: Colors.black.withOpacity(0.3),
          //     ),
          //   ),
          // ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ClipOval(
                        child: Material(
                          color: DevThemeConfig.devBackgroundColor,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: DevThemeConfig.devPrimaryColor),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Scrollable card content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Register",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: DevThemeConfig.devPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Create your new account",
                              style: TextStyle(
                                color: DevThemeConfig.devPrimaryColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              context,
                              controller: _emailController,
                              hintText: "Email",
                              icon: Icons.email,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              context,
                              controller: _passwordController,
                              hintText: "Password",
                              icon: Icons.lock,
                              isPassword: true,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              context,
                              controller: _usernameController,
                              hintText: "Username",
                              icon: Icons.person,
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              context,
                              controller: _phoneController,
                              hintText: "Phone Number",
                              icon: Icons.phone,
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _registerUser,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      DevThemeConfig.devPrimaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()),
                                  );
                                },
                                child: Text.rich(
                                  TextSpan(
                                    text: "Already have an account? ",
                                    style: TextStyle(color: Colors.grey),
                                    children: [
                                      TextSpan(
                                        text: "Sign in",
                                        style: TextStyle(
                                          color: DevThemeConfig.devPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context,
      {required String hintText,
      required IconData icon,
      required TextEditingController controller,
      bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        filled: true,
        fillColor: DevThemeConfig.devPrimaryColor.withOpacity(0.1),
        prefixIcon: Icon(icon, color: DevThemeConfig.devPrimaryColor),
        hintText: hintText,
        hintStyle: TextStyle(
          color: DevThemeConfig.devPrimaryColor.withOpacity(0.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: DevThemeConfig.devPrimaryColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
