import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/food_item.dart'; // Ensure that this is correctly imported
import '../services/mock_data.dart'; // Make sure this contains mock data

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  AllProductsScreenState createState() => AllProductsScreenState();
}

class AllProductsScreenState extends State<AllProductsScreen> {
  String searchQuery = '';
  double minPrice = 0;
  double maxPrice = 100;
  bool newDealsOnly = false;
  List<FoodItem> filteredItems = [];
  List<String> categories = [
    'All',
    'Pizza',
    'Burger',
    'Coffee',
    'Donut',
    'Salad',
    'Biryani',
    'Fast Food',
    'Cake'
  ];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(mockFoodItems); // Initialize with all items
  }

  // Filtering logic
  void filterItems() {
    setState(() {
      filteredItems = mockFoodItems.where((item) {
        final matchesSearch =
            item.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesPrice = item.price >= minPrice && item.price <= maxPrice;
        final matchesDeals = !newDealsOnly || item.isNewDeal;
        final matchesCategory =
            selectedCategory == 'All' || item.category == selectedCategory;

        return matchesSearch && matchesPrice && matchesDeals && matchesCategory;
      }).toList();
    });
  }

  // Handle category change
  void onCategoryChange(String category) {
    setState(() {
      selectedCategory = category;
    });
    filterItems(); // Filter immediately
  }

  // Show the filter bottom sheet
  void showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height *
              0.55, // 55% of the screen height
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter by Category',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: FilterChip(
                          label: Text(category),
                          selected: selectedCategory == category,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                            filterItems(); // Apply category filter immediately
                            Navigator.of(context)
                                .pop(); // Close the filter modal
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Price Range',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                RangeSlider(
                  min: 0,
                  max: 100,
                  values: RangeValues(minPrice, maxPrice),
                  onChanged: (RangeValues values) {
                    setState(() {
                      minPrice = values.start;
                      maxPrice = values.end;
                    });
                    filterItems(); // Apply price filter immediately
                  },
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text('New Deals Only'),
                  value: newDealsOnly,
                  onChanged: (bool? value) {
                    setState(() {
                      newDealsOnly = value ?? false;
                    });
                    filterItems(); // Apply new deals filter immediately
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the filter modal
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFFFD700); // Gold accent color
    const Color premiumGreen =
        Color(0xFF006400); // Premium Green color for the app

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Products',
          style: TextStyle(
            color: gold, // Set gold color for the title
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: premiumGreen, // Green for a premium touch
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: showFilterBottomSheet, // Show filters on button press
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search Products',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: premiumGreen),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchQuery = '';
                            });
                            filterItems(); // Apply search filter immediately
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  filterItems(); // Apply search filter immediately
                },
              ),
            ),

            // Grid of Products
            Expanded(
              child: filteredItems.isNotEmpty
                  ? GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (ctx, index) {
                        final foodItem = filteredItems[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/details',
                              arguments: foodItem,
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 10,
                            shadowColor: Colors.black.withOpacity(0.25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Stack(
                                  children: [
                                    // Product Image
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(15)),
                                      child: foodItem.image.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: foodItem.image,
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            )
                                          : const Icon(Icons.error),
                                    ),
                                    // "New Deal" Label
                                    if (foodItem.isNewDeal)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          decoration: BoxDecoration(
                                            color: gold.withOpacity(0.9),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'New Deal!',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        foodItem.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        '\$${foodItem.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        foodItem.brand,
                                        style: const TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text('No products match the filters')),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showFilterBottomSheet,
        backgroundColor: premiumGreen,
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }
}
