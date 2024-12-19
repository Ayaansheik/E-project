import 'package:flutter/material.dart';
import 'package:myapp/widgets/famous_author_section.dart';
import 'package:myapp/widgets/categories_section.dart';
import '../widgets/book_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/carousel_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CustomAppBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Carousel Banner Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: CarouselBanner(),
                  ),
                  // Category Section
                  CategoryGrid(),
                  // Banner Section
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green[400], // Banner background color
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Free Delivery On First Two Orders!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/all-products');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Order Now',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Author Section are from widget famous_author_section.dart
                  const AuthorSection(),
                  // card are from widgets book_card.dart
                  BookListWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
