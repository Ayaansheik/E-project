// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:myapp/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberMe = true;

  // Function to register a new user
  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Please fill in all fields");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Clear input fields after successful registration
      _emailController.clear();
      _passwordController.clear();

      // Show success message
      // _showSnackbar("Registration successful!");

      // Show dialog after registration
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Registration successful!'),
              ],
            ),
          );
        },
      );

      // Navigate to login screen after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
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
        backgroundColor: const Color(0xFF006400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        // Only this SingleChildScrollView is needed
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                'https://drive.usercontent.google.com/download?id=17N1MtvgJ01cZm3B3pd8N6I_Yv7rgGVgL&export=view&authuser=0',
              ), // Background image URL
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            // SafeArea should be wrapped here
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Create your new account",
                          style: TextStyle(
                            color: Colors.grey,
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _registerUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Register",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: const Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.grey),
                              children: [
                                TextSpan(
                                  text: "Sign in",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.green.withOpacity(0.1),
        prefixIcon: Icon(icon, color: Colors.green),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.green.shade400),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
