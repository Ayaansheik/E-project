// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/home_screen.dart'; // Import HomeScreen
import 'package:myapp/screens/register_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Method to handle login
  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both email and password.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Attempt to sign in the user
      // ignore: unused_local_variable
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Show a success message in the center of the screen
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Login successful!'),
              ],
            ),
          );
        },
      );

      // Wait for a few seconds, then navigate to the HomeScreen
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context); // Close the dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    } on FirebaseAuthException catch (e) {
      // Handle Firebase exceptions
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Login to your account",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.green.withOpacity(0.1),
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.green),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Colors.green.shade400),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.green.withOpacity(0.1),
                        prefixIcon: const Icon(Icons.lock, color: Colors.green),
                        suffixIcon: Icon(Icons.visibility_off,
                            color: Colors.green.shade400),
                        hintText: "Password",
                        hintStyle: TextStyle(color: Colors.green.shade400),
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
                              value: true,
                              onChanged: (_) {},
                              activeColor: Colors.green,
                            ),
                            const Text(
                              "Remember Me",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loginUser, // Use the login method here
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
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
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                text: "Sign up",
                                style: TextStyle(
                                  color: Colors.green,
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
              const Spacer(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
