import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/checkout_screen.dart';
import 'package:myapp/screens/demo_screen.dart';
import 'package:myapp/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'screens/new_deals_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/food_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/all_products_screen.dart';
import 'screens/splash_screen.dart';
import 'providers/cart_provider.dart';
import 'models/cart_item.dart';
import 'firebase_options.dart';

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
      title: 'Bitezi',
      theme: ThemeData(
        primaryColor: const Color(0xFF006400), // premiumGreen
        hintColor: const Color(0xFFFFD700), // gold
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodyLarge: TextStyle(fontSize: 16),
          labelLarge: TextStyle(fontSize: 16),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFFFD700), // gold
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD700), // gold accent color
          ),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF006400), // premiumGreen
        ),
      ),
      home: const SplashScreenHandler(),
      routes: {
        '/demo': (context) => DemoScreen(),
        // '/home': (context) => BookListWidget(),
        '/home': (context) => HomeScreen(),
        '/details': (context) => const FoodDetailScreen(),
        '/cart': (context) => const CartScreen(),
        '/new-deals': (context) => const NewDealsScreen(),
        '/checkout': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return CheckoutScreen(
            cartItems: args['cartItems'] as List<CartItem>,
            totalAmount: args['totalAmount'] as double,
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
