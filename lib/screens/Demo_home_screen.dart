// // ignore: file_names
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // To control system UI (status bar)
// import 'package:myapp/screens/categoryproducts_screen.dart';

// import 'package:myapp/screens/new_deals_screen.dart';
// import 'package:myapp/widgets/brand_logo_section.dart';
// import '../services/mock_data.dart';
// import '../widgets/food_card.dart';
// import '../widgets/custom_app_bar.dart';
// import '../widgets/carousel_banner.dart';

// class HomeScreen extends StatelessWidget {
//   final List<String> imageUrls = [
//     'https://drive.google.com/uc?id=1qxE_FNB3HsjK6ToxovgZT27YR4KtYaIW',
//     'https://drive.google.com/uc?id=1-zlw_pbJFQPNjSpj6wdiwUmkIXn6A5ma',
//     'https://drive.google.com/uc?id=1VvPTkYxMDB6Lr9-wA5AQxgb6zjQaMAgy',
//     'https://drive.google.com/uc?id=1GZ9y7ySZFU63CNrWvkzNSwxuXQJzlL5f',
//     'https://drive.google.com/uc?id=1lJ5ov15ZQKeGwnJchUt_bRXH4eAoWFXx',
//   ];

//   final List<String> brandLogoUrls = [
//     'https://drive.google.com/uc?id=1NX6yzs9gxziSzlP0TyI6x7Nykoh0u0QZ',
//     'https://drive.google.com/uc?id=1Lb2LutFkYMvmo7Q2DZ5uHRjBvJ8TbTtd',
//     'https://drive.google.com/uc?id=1nS8NW5Qvq0U4hgzQorgsPtVU4xrj4bFF',
//     'https://drive.google.com/uc?id=1L-_mQHME7gDMS_zTXwj-NWiIcNsx_TzX',
//     'https://drive.google.com/uc?id=17OfEIehxaQxlpfUWs3WLGP0fcqwpOe44',
//     'https://drive.google.com/uc?id=1Rwj79zUkhpTvzYS3p4_AVtDm0VatXf-H',
//   ];

//   final List<Map<String, String>> categories = [
//     {
//       'name': 'Offers',
//       'iconPath':
//           'https://drive.google.com/uc?id=1VPMrYdO5Yoxvy8YMw9xPZ9bIRcFEOlyF',
//     },
//     {
//       'name': 'Cake',
//       'iconPath':
//           'https://drive.google.com/uc?id=1vpVRBCMRrG2hXPRa80K9YpROtC7Qo2sO',
//     },
//     {
//       'name': 'Biryani',
//       'iconPath':
//           'https://drive.google.com/uc?id=1bbvxtQeIa_rouZYb-dXf_QS0_BU93Omf',
//     },
//     {
//       'name': 'Burger',
//       'iconPath':
//           'https://drive.google.com/uc?id=1RZSOYfC0yCt3vSndTtJasv5jzSWpL5V2',
//     },
//     {
//       'name': 'Pizza',
//       'iconPath':
//           'https://drive.google.com/uc?id=1rPAwoOrwcHQTk3Bzf8c9CXNGuNbfgCnB',
//     },
//     {
//       'name': 'Coffee',
//       'iconPath':
//           'https://drive.google.com/uc?id=1NG09QwqNvDbfKQW-f7E_khjHYfllxV8-',
//     },
//     {
//       'name': 'Donut',
//       'iconPath':
//           'https://drive.google.com/uc?id=125_AOTLceuWfxBLRDG3pDWbjdoeZqhQk',
//     },
//     {
//       'name': 'Salad',
//       'iconPath':
//           'https://drive.google.com/uc?id=15TGgiyWZf5tL9zbnfC_GU6NbzRPuUAW6',
//     },
//   ];

//   HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     const premiumGreen = Color(0xFF006400); // Dark Green for AppBar background

//     // Set the status bar color and icon brightness to match AppBar's color
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: premiumGreen, // Match AppBar's background color
//       statusBarIconBrightness:
//           Brightness.light, // Light icons for dark background
//     ));

//     final newDeals = mockFoodItems.where((item) => item.isNewDeal).toList();
//     final topSelling =
//         mockFoodItems.where((item) => item.isTopSelling).toList();

//     return Scaffold(
//       body: SafeArea(
//         child: CustomScrollView(
//           slivers: [
//             const CustomAppBar(),
//             SliverList(
//               delegate: SliverChildListDelegate(
//                 [
//                   SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Carousel Banner Section
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 15.0),
//                           child: CarouselBanner(imageUrls: imageUrls),
//                         ),

//                         // Category Grid Section
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12.0, vertical: 10),
//                           child: GridView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 4,
//                               childAspectRatio: 1,
//                               mainAxisSpacing: 12,
//                               crossAxisSpacing: 12,
//                             ),
//                             itemCount: categories.length,
//                             itemBuilder: (context, index) {
//                               final category = categories[index];
//                               return GestureDetector(
//                                 onTap: () {
//                                   // Navigate to the CategoryProductsScreen with the selected category
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           categoryproductsscreen(
//                                         categoryName: category['name']!,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Container(
//                                       height: 55,
//                                       width: 55,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         shape: BoxShape.circle,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.grey.withOpacity(0.3),
//                                             blurRadius: 10,
//                                             offset: const Offset(0, 5),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Padding(
//                                         padding: const EdgeInsets.all(12.0),
//                                         child: CachedNetworkImage(
//                                           imageUrl: category[
//                                               'iconPath']!, // The icon path from the category
//                                           fit: BoxFit.contain,
//                                           placeholder: (context, url) =>
//                                               const CircularProgressIndicator(), // Show a loader while the image loads
//                                           errorWidget: (context, url, error) =>
//                                               const Icon(Icons
//                                                   .error), // Show an error icon if image fails to load
//                                         ),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Text(
//                                       category['name']!,
//                                       style: const TextStyle(
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),

//                         // Banner Section
//                         Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color:
//                                   Colors.green[400], // Banner background color
//                               borderRadius: BorderRadius.circular(15),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   blurRadius: 10,
//                                   offset: const Offset(0, 5),
//                                 ),
//                               ],
//                             ),
//                             padding: const EdgeInsets.all(16),
//                             child: Row(
//                               children: [
//                                 const Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         'Free Delivery On First Two Orders!',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(width: 10),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.pushNamed(
//                                         context, '/all-products');
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.white,
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 20, vertical: 12),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(30),
//                                     ),
//                                     elevation: 5,
//                                   ),
//                                   child: const Text(
//                                     'Order Now',
//                                     style: TextStyle(
//                                       color: Colors.green,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),

//                         // Top Brands Section
//                         BrandLogoSection(brandLogoUrls: brandLogoUrls),
//                         // New Deals Section
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 12.0, vertical: 10),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text(
//                                 "New Deals",
//                                 style: TextStyle(
//                                     fontSize: 24, fontWeight: FontWeight.bold),
//                               ),
//                               IconButton(
//                                 icon: const Icon(Icons.arrow_forward,
//                                     color: Colors.green),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                           const NewDealsScreen(),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                           child: GridView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 1,
//                               childAspectRatio: 2.3,
//                               crossAxisSpacing: 15,
//                               mainAxisSpacing: 15,
//                             ),
//                             itemCount: newDeals.length,
//                             itemBuilder: (ctx, index) {
//                               final foodItem = newDeals[index];
//                               return FoodCard(foodItem: foodItem);
//                             },
//                           ),
//                         ),

//                         // Top Selling Section
//                         const Padding(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 12.0, vertical: 10),
//                           child: Text(
//                             "Top Selling",
//                             style: TextStyle(
//                                 fontSize: 24, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                           child: GridView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 1,
//                               childAspectRatio: 2.3,
//                               crossAxisSpacing: 15,
//                               mainAxisSpacing: 15,
//                             ),
//                             itemCount: topSelling.length,
//                             itemBuilder: (ctx, index) {
//                               final foodItem = topSelling[index];
//                               return FoodCard(foodItem: foodItem);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
