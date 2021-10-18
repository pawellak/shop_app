import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products extends ChangeNotifier {
  List<Product> _items = [];

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
    try {
      final url = Uri.https(
          'udemy-shopapp-pl-default-rtdb.firebaseio.com', '/products.json');
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite
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

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'udemy-shopapp-pl-default-rtdb.firebaseio.com', '/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if(extractedData==null) return;
      List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          isFavorite: value['isFavorite'],
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
    final url = Uri.https(
        'udemy-shopapp-pl-default-rtdb.firebaseio.com', '/products/$id.json');

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
    final url = Uri.https(
        'udemy-shopapp-pl-default-rtdb.firebaseio.com', '/products/$id.json');
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
