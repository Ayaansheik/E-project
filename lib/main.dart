import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/all_products_screen.dart';
import 'package:myapp/screens/auhtor_screen.dart';
import 'package:myapp/screens/author_detail_screen.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/order_tracking.dart';
import 'package:myapp/screens/user_profile_screen.dart';
import 'package:myapp/widgets/address_screen.dart';
import 'package:myapp/widgets/my_details_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    Bookapp(),
  );
}

class Bookapp extends StatelessWidget {
  const Bookapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BOOKIFIER',
      home: const SplashScreenHandler(),
      routes: {
        '/userprofile': (context) => UserProfileScreen(),
        '/allauthors': (context) => AuthorScreen(),
        '/home': (context) => HomeScreen(),
        '/authorDetails': (context) => AuthorDetailScreen(),
        '/userdetailscreen': (context) => const MyDetailsScreen(
              userData: {},
            ),
        '/useraddress': (context) => const MakeAddressScreen(
              userData: {},
            ),
        '/cart': (context) => const CartScreen(),
        '/trackingorder': (context) => const OrderTrackingPage(),
        '/all-products': (context) => const AllProductsScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

class SplashScreenHandler extends StatefulWidget {
  const SplashScreenHandler({super.key});

  @override
  SplashScreenHandlerState createState() => SplashScreenHandlerState();
}

class SplashScreenHandlerState extends State<SplashScreenHandler> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
