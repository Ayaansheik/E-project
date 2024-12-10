// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(String id, String name, double price, int quantity) {
    if (quantity <= 0) {
      return; // Prevent adding items with non-positive quantity
    }

    if (_items.containsKey(id)) {
      _items.update(
        id,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
          id: id,
          name: name,
          price: price,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return; // If the item is not in the cart, do nothing
    }
    if (_items[id]!.quantity > 1) {
      _items.update(
        id,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          quantity: existingItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear(); // Use clear() method for better clarity
    notifyListeners();
  }

  @override
  String toString() {
    return 'CartProvider(items: $_items)';
  }
}
