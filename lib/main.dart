import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/all_products_screen.dart';
import 'package:myapp/screens/auhtor_screen.dart';
import 'package:myapp/screens/checkout_screen.dart';
import 'package:myapp/screens/author_detail_screen.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:myapp/screens/order_tracking.dart';
import 'package:myapp/screens/user_profile_screen.dart';
import 'package:myapp/widgets/address_screen.dart';
import 'package:myapp/widgets/my_details_screen.dart';
import 'package:provider/provider.dart';
import 'screens/new_deals_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/food_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/splash_screen.dart';
import 'providers/cart_provider.dart';
import 'models/cart_item.dart';
import 'firebase_options.dart';
// ignore: unused_import
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const FoodDeliveryApp(),
    ),
  );
}

class FoodDeliveryApp extends StatelessWidget {
  const FoodDeliveryApp({super.key});

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
        '/details': (context) => const FoodDetailScreen(),
        '/userdetailscreen': (context) => const MyDetailsScreen(
              userData: {},
            ),
        '/useraddress': (context) => const MakeAddressScreen(
              userData: {},
            ),
        '/cart': (context) => const CartScreen(),
        '/trackingorder': (context) => const OrderTrackingPage(),
        '/new-deals': (context) => const NewDealsScreen(),
        '/checkout': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          if (args == null ||
              args['cartItems'] == null ||
              args['totalAmount'] == null ||
              args['cartItems'] is! List<CartItem> ||
              args['totalAmount'] is! double ||
              args['userId'] == null || // Check for userId
              args['userId'] is! String) {
            // Validate userId type
            throw Exception('Invalid arguments for /checkout route');
          }

          return CheckoutScreen(
            cartItems: args['cartItems'] as List<CartItem>,
            totalAmount: args['totalAmount'] as double,
            userId: args['userId'] as String, // Pass userId to CheckoutScreen
          );
        },
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
