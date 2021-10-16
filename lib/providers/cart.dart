import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.quantity,
      required this.price});
}

class Cart with ChangeNotifier {
  late final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else {
      if (_items[productId]!.quantity > 1) {
        _items.update(
            productId,
            (value) => CartItem(
                id: value.id,
                title: value.title,
                quantity: value.quantity - 1,
                price: value.price));
      } else {
        _items.remove(productId);
      }
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.price;
    });
    return total;
  }

  void addItem(
      {required String productId,
      required double price,
      required String title}) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCardItem) => CartItem(
              id: existingCardItem.id,
              title: existingCardItem.title,
              quantity: existingCardItem.quantity + 1,
              price: existingCardItem.price));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              price: price));
    }
    notifyListeners();
  }
}
