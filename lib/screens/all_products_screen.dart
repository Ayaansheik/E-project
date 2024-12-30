import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myapp/widgets/theme_color.dart';
import '../models/food_item.dart';
import '../services/mock_data.dart';

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
    _applyFilters(); // Initialize with filtered items
  }

  /// Apply all filters to the food items
  void _applyFilters() {
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

  /// Show the filter bottom sheet
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter by Category',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            DevThemeConfig.devPrimaryColor, // Use theme color
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: FilterChip(
                              label: Text(category),
                              selected: selectedCategory == category,
                              onSelected: (bool selected) {
                                setModalState(() {
                                  selectedCategory = category;
                                });
                                _applyFilters(); // Apply filter dynamically
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Price Range',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            DevThemeConfig.devPrimaryColor, // Use theme color
                      ),
                    ),
                    RangeSlider(
                      min: 0,
                      max: 100,
                      values: RangeValues(minPrice, maxPrice),
                      onChanged: (RangeValues values) {
                        setModalState(() {
                          minPrice = values.start;
                          maxPrice = values.end;
                        });
                        _applyFilters(); // Apply price filter dynamically
                      },
                      divisions: 10,
                      labels: RangeLabels(
                        '\$${minPrice.toStringAsFixed(0)}',
                        '\$${maxPrice.toStringAsFixed(0)}',
                      ),
                    ),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      title: Text(
                        'New Deals Only',
                        style: TextStyle(
                          color: DevThemeConfig.devPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: newDealsOnly,
                      onChanged: (bool? value) {
                        setModalState(() {
                          newDealsOnly = value ?? false;
                        });
                        _applyFilters(); // Apply new deals filter dynamically
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the filter modal
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: DevThemeConfig.devBackgroundColor,
                        backgroundColor:
                            DevThemeConfig.devPrimaryColor, // Use theme color
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = DevThemeConfig.devAppTheme; // Get the custom theme
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Products',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        iconTheme: IconThemeData(
          color: DevThemeConfig
              .devBackgroundColor, // Set the back button color to match the primary color
        ),

        backgroundColor: theme.primaryColor, // Use theme color
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterBottomSheet,
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
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchQuery = '';
                            });
                            _applyFilters();
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                  _applyFilters();
                },
              ),
            ),
            // Product Grid
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                  child: CachedNetworkImage(
                                    imageUrl: foodItem.image,
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
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
                                        style: TextStyle(
                                          color: theme
                                              .primaryColor, // Use theme color
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        foodItem.brand,
                                        style: const TextStyle(fontSize: 13),
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
        onPressed: _showFilterBottomSheet,
        backgroundColor: theme.primaryColor, // Use theme color
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }
}
