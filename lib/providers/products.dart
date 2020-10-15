import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/utilities/api_url.dart';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;
  List<Product> _items = [];

  Products({this.authToken, this.userId, Products prevState}) {
    if (prevState != null) {
      _items = prevState._items;
    }
  }

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

  Future<void> fetchAndSetProducts({bool isFilterByUser = false}) async {
    final filterByUserUrl =
        isFilterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final response = await get('${ApiUrl.products(authToken)}$filterByUserUrl');
    final Map<String, dynamic> responseBody = json.decode(response.body);

    if (response.statusCode >= 400 || responseBody == null) {
      throw HttpException('Unable to fetch products');
    }

    final userFavResponse = await get(
      ApiUrl.getUserFavoriteProductUrl(
        userId: userId,
        token: authToken,
      ),
    );
    final Map<String, dynamic> userFavBody = json.decode(userFavResponse.body);

    List<Product> results = [];

    responseBody.forEach((prodId, prodValue) {
      results.add(Product(
        id: prodId,
        title: prodValue['title'],
        description: prodValue['description'],
        imageUrl: prodValue['imageUrl'],
        price: prodValue['price'],
        isFavorite: userFavBody == null ? false : userFavBody[prodId] ?? false,
      ));
    });

    _items = results;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final body = json.encode({
      'title': product.title,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'price': product.price,
      'creatorId': userId
    });
    final response = await post(
      ApiUrl.products(authToken),
      body: body,
    );

    if (response.statusCode >= 400) {
      throw HttpException('Can\'t adding orders');
    }

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
      final response = await patch(
        ApiUrl.getProductUrl(product.id, authToken),
        body: body,
      );

      if (response.statusCode >= 400) {
        throw HttpException('Can\'t adding orders');
      }

      _items[productIndex] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String id) async {
    final deletedProductIndex = _items.indexWhere((el) => el.id == id);
    final response = await delete(ApiUrl.getProductUrl(id, authToken));

    if (response.statusCode >= 400) {
      throw HttpException('Could not delete product.');
    }

    _items.removeAt(deletedProductIndex);
    notifyListeners();
  }
}
