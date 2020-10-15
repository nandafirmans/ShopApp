import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:shop_app/utilities/api_url.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite({String userId, String token}) async {
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await put(
        ApiUrl.getUserFavoriteProductUrl(
          productId: id,
          userId: userId,
          token: token,
        ),
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Failed to toggle favorite');
      }
    } catch (error) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
