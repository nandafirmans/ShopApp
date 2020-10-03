import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/utilities/api_url.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((p) => p.isFavorite).toList();
  }

  Product findById(String id) {
    if (id == null) {
      return null;
    }

    return _items.firstWhere((p) => p.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final response = await get(ApiUrl.products);
    final Map<String, dynamic> responseBody = json.decode(response.body);
    final List<Product> loadedProducts = responseBody.entries
        .map(
          (entry) => Product(
            id: entry.key,
            title: entry.value['title'],
            description: entry.value['description'],
            imageUrl: entry.value['imageUrl'],
            price: entry.value['price'],
            isFavorite: entry.value['isFavorite'],
          ),
        )
        .toList();

    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final body = json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'isFavorite': product.isFavorite,
    });
    final response = await post(ApiUrl.products, body: body);
    final responseBody = json.decode(response.body);
    final newProduct = Product(
      id: responseBody['name'],
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );

    _items.add(newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final productIndex = _items.indexWhere((p) => p.id == product.id);

    if (productIndex >= 0) {
      final body = json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
      });
      await patch(ApiUrl.product(product.id), body: body);
      _items[productIndex] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {
    final deletedProductIndex = _items.indexWhere((el) => el.id == id);
    final response = await delete(ApiUrl.product(id));

    if (response.statusCode == 200) {
      _items.removeAt(deletedProductIndex);
      notifyListeners();
    }

    if (response.statusCode >= 400) {
      throw HttpException('Could not delete product.');
    }
  }
}
