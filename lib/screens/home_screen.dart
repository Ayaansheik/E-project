import 'package:flutter/material.dart';
import 'package:myapp/widgets/bottom_app_bar.dart';
import 'package:myapp/widgets/custom_drawer.dart';
import 'package:myapp/widgets/famous_author_section.dart';
import 'package:myapp/widgets/categories_section.dart';
import 'package:myapp/widgets/theme_color.dart';
import '../widgets/book_card.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/carousel_banner.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const CustomAppBar(),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // Search Bar Section
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for books or authors...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onSubmitted: (query) {
                        if (query.isNotEmpty) {
                          Navigator.pushNamed(
                            context,
                            '/all-products',
                            arguments: query, // Pass search query as argument
                          );
                        }
                      },
                    ),
                  ),
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
                        color: DevThemeConfig
                            .devPrimaryColor, // Banner background color
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
                                    // color: Colors.white,
                                    color: DevThemeConfig.devBackgroundColor,
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
                              backgroundColor:
                                  DevThemeConfig.devBackgroundColor,
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
                                color: DevThemeConfig.devPrimaryColor,
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
      bottomNavigationBar: BottomAppBarWidget(),
    );
  }
}
