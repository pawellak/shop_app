import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void setFavoriteValue(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  void toggleFavouriteStatus(String authToken,String userId) async {
    var params = {
      'auth': authToken,
    };
    bool? _isFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.https(
        'udemy-shopapp-pl-default-rtdb.firebaseio.com', '/userFavorites/$userId/$id.json',params);

    try {
      final response =
          await http.put(url, body: json.encode(isFavorite));

      if (response.statusCode >= 400) {
        setFavoriteValue(_isFavorite);
        throw HttpException('Could not toggle favorite status');
      }
    } catch (exception) {
      setFavoriteValue(_isFavorite);
      rethrow;
    }

    _isFavorite = null;
  }
}
