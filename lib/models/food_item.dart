class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final String brand;
  final bool isNewDeal;
  final bool isTopSelling;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.brand,
    this.isNewDeal = false,
    this.isTopSelling = false,
  });

  // Factory method to create a FoodItem from JSON
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(), // Ensure it's double
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'] ?? 'Unknown',
      isNewDeal: json['isNewDeal'] ?? false,
      isTopSelling: json['isTopSelling'] ?? false,
    );
  }

  // Method to convert FoodItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'brand': brand,
      'isNewDeal': isNewDeal,
      'isTopSelling': isTopSelling,
    };
  }

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, description: $description, category: $category, price: $price, image: $image, brand: $brand, isNewDeal: $isNewDeal, isTopSelling: $isTopSelling)';
  }

  static fromFirestore(Map<String, dynamic> data, String id) {}
}
