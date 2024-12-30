import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoOpacity;
  final List<AnimationController> _iconControllers = [];
  final List<Animation<Offset>> _iconAnimations = [];
  final List<Animation<double>> _iconRotations = [];
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Paths for icons
  final List<String> iconPaths = [
    'https://drive.google.com/uc?export=view&id=1VPMrYdO5Yoxvy8YMw9xPZ9bIRcFEOlyF',
    'https://drive.google.com/uc?export=view&id=125_AOTLceuWfxBLRDG3pDWbjdoeZqhQk',
    'https://drive.google.com/uc?export=view&id=1RZSOYfC0yCt3vSndTtJasv5jzSWpL5V2',
    'https://drive.google.com/uc?export=view&id=15TGgiyWZf5tL9zbnfC_GU6NbzRPuUAW6',
    'https://drive.google.com/uc?export=view&id=1rPAwoOrwcHQTk3Bzf8c9CXNGuNbfgCnB',
    'https://drive.google.com/uc?export=view&id=1NG09QwqNvDbfKQW-f7E_khjHYfllxV8-',
    'https://drive.google.com/uc?export=view&id=1vpVRBCMRrG2hXPRa80K9YpROtC7Qo2sO',
    'https://drive.google.com/uc?export=view&id=1bbvxtQeIa_rouZYb-dXf_QS0_BU93Omf',
  ];

  late String _displayText;
  // ignore: unused_field
  late int _currentIndex;

  @override
  void initState() {
    super.initState();

    // Animation controller for the bookifier logo
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _logoController.forward();

    _displayText = "";
    _currentIndex = 0;

    // Typing effect
    Future.delayed(const Duration(milliseconds: 500), _startTypingEffect);

    // Check login status after animations
    Future.delayed(const Duration(seconds: 3), _checkLoginStatus);

    // Initialize icon animations
    _initializeIconAnimations();
  }

  Future<void> _checkLoginStatus() async {
    // Check for login data in secure storage
    String? userEmail = await _secureStorage.read(key: 'user_email');
    String? userDocId = await _secureStorage.read(key: 'user_doc_id');

    // Navigate based on the presence of stored credentials
    if (userEmail != null && userDocId != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _initializeIconAnimations() {
    final List<Offset> iconStartOffsets = [
      const Offset(-1.2, -1.2),
      const Offset(1.2, -1.0),
      const Offset(-0.8, 1.2),
      const Offset(1.5, 0.8),
      const Offset(0.5, 1.5),
      const Offset(-1.5, 0.5),
      const Offset(1.0, -0.5),
      const Offset(-2.5, -1),
    ];

    for (int i = 0; i < iconPaths.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1200),
      );

      final offsetAnimation = Tween<Offset>(
        begin: iconStartOffsets[i],
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.elasticOut));

      final rotationAnimation = Tween<double>(
        begin: -0.5,
        end: 0.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      _iconControllers.add(controller);
      _iconAnimations.add(offsetAnimation);
      _iconRotations.add(rotationAnimation);

      Future.delayed(Duration(milliseconds: 400 * i), () {
        controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    for (var controller in _iconControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startTypingEffect() {
    const text = 'Bookifier';
    const duration = Duration(milliseconds: 200);

    Future.delayed(Duration.zero, () {
      for (int i = 0; i < text.length; i++) {
        Future.delayed(duration * i, () {
          setState(() {
            _displayText += text[i];
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF004d00), Color(0xFF006600)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Animated bookifier Logo (typing effect)
          Center(
            child: FadeTransition(
              opacity: _logoOpacity,
              child: Text(
                _displayText,
                style: TextStyle(
                  fontSize: 54.0,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Colors.yellow, Colors.orangeAccent],
                    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                ),
              ),
            ),
          ),

          // Animated Icons
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.07,
            child: _buildAnimatedIcon(0),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            right: MediaQuery.of(context).size.width * 0.13,
            child: _buildAnimatedIcon(1),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.45,
            child: _buildAnimatedIcon(2),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: MediaQuery.of(context).size.width * 0.1,
            child: _buildAnimatedIcon(3),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.42,
            right: MediaQuery.of(context).size.width * 0.02,
            child: _buildAnimatedIcon(4),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.1,
            child: _buildAnimatedIcon(5),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            right: MediaQuery.of(context).size.width * 0.13,
            child: _buildAnimatedIcon(6),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.31,
            left: MediaQuery.of(context).size.width * 0.3,
            child: _buildAnimatedIcon(7),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon(int index) {
    return SlideTransition(
      position: _iconAnimations[index],
      child: RotationTransition(
        turns: _iconRotations[index],
        child: _buildIcon(iconPaths[index]),
      ),
    );
  }

  Widget _buildIcon(String assetPath) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CachedNetworkImage(
          imageUrl: assetPath,
          fit: BoxFit.contain,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
