// lib/models/order_detail.dart

class OrderDetail {
  final String imageUrl;
  final String title;
  final int quantity;
  final double price;
  final int stage;
  final int daysLeft;

  OrderDetail({
    required this.imageUrl,
    required this.title,
    required this.quantity,
    required this.price,
    required this.stage,
    required this.daysLeft,
  });
   // Factory constructor to create OrderDetail from Firebase data
  factory OrderDetail.fromMap(Map<dynamic, dynamic> data) {
    return OrderDetail(
      title: data['title'],
      quantity: data['quantity'],
      price: data['price'],
      stage: data['stage'],
      daysLeft: data['daysLeft'],
      imageUrl: data['imageUrl'],
    );
  }
}
