import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:myapp/widgets/theme_color.dart';

class FilterWidget extends StatelessWidget {
  final String selectedCategory;
  final List<String> categories;
  final double minPrice;
  final double maxPrice;
  final bool showBestSellers;
  final Function(String?) onCategoryChanged; // Nullable String
  final Function(double) onMinPriceChanged;
  final Function(double) onMaxPriceChanged;
  final Function(bool?) onBestSellersChanged; // Nullable Bool
  final VoidCallback onApplyFilters;

  const FilterWidget({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.minPrice,
    required this.maxPrice,
    required this.showBestSellers,
    required this.onCategoryChanged,
    required this.onMinPriceChanged,
    required this.onMaxPriceChanged,
    required this.onBestSellersChanged,
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filters',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: onCategoryChanged, // Accepts nullable String
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min Price',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      onMinPriceChanged(double.tryParse(value) ?? 0);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max Price',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      onMaxPriceChanged(
                          double.tryParse(value) ?? double.infinity);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('Best Sellers'),
              value: showBestSellers,
              onChanged: onBestSellersChanged, // Accepts nullable bool
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onApplyFilters,
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
