import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products extends ChangeNotifier {
  final String? authToken;
  final String userId;
  List<Product> _items = [];

  Products(
    this.authToken,
    this.userId,
    this._items,
  );

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorite {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) async {
    var params = {
      'auth': authToken,
    };

    try {
      final url = Uri.https('udemy-shopapp-pl-default-rtdb.firebaseio.com',
          '/products.json', params);
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchAndSetProducts({bool filterByUser = false}) async {
    var _params = {
      'auth': authToken,
    };

    if (filterByUser) {
      _params = {
        'auth': authToken,
        'orderBy': json.encode("creatorId"),
        'equalTo': json.encode(userId),
      };
    }

    var url = Uri.https(
      'udemy-shopapp-pl-default-rtdb.firebaseio.com',
      '/products.json',
      _params,
    );

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) return;
      List<Product> loadedProducts = [];

      url = Uri.https('udemy-shopapp-pl-default-rtdb.firebaseio.com',
          '/userFavorites/$userId.json', _params);

      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      extractedData.forEach((prodId, value) {
        loadedProducts.add(Product(
          id: prodId,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: value['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (exception) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    var params = {
      'auth': authToken,
    };

    final url = Uri.https('udemy-shopapp-pl-default-rtdb.firebaseio.com',
        '/products/$id.json', params);

    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    try {
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          }));
    } catch (error) {
      rethrow;
    }
    if (prodIndex >= 0) {
      _items[prodIndex] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {
    var params = {
      'auth': authToken,
    };

    final url = Uri.https('udemy-shopapp-pl-default-rtdb.firebaseio.com',
        '/products/$id.json', params);
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items.firstWhere((element) => element.id == id);

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
