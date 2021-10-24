import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dataTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dataTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken,this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    var params = {
      'auth': authToken,
    };

    final url = Uri.https(
        'udemy-shopapp-pl-default-rtdb.firebaseio.com', '/$userId/orders.json', params);

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];

    final Map<String, dynamic>? extractedData =
        json.decode(response.body) as Map<String, dynamic>?;

    if (extractedData == null) return;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
          dataTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartProducts, double total) async {
    var params = {
      'auth': authToken,
    };

    final url = Uri.https(
        'udemy-shopapp-pl-default-rtdb.firebaseio.com', '/$userId/orders.json', params);

    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dataTime: timeStamp));
    notifyListeners();
  }
}
