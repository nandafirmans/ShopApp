import 'package:shop_app/models/auth_mode.dart';

class ApiUrl {
  static const _apiHost = 'https://flutter-shop-app-44b4c.firebaseio.com';
  static const _apiKey = 'AIzaSyAxbF9IHa48SC5e6GKmCKizJWkkAodHvNM';
  static const _products = '$_apiHost/products';
  static const _orders = '$_apiHost/orders';

  static String products(String token) {
    return _appendDotJsonAndToken(_products, token);
  }

  static String getProductUrl(String id, String token) {
    return _appendDotJsonAndToken('$_products/$id', token);
  }

  static String orders({
    String token,
    String userId,
  }) {
    return _appendDotJsonAndToken('$_orders/$userId', token);
  }

  static String getOrderUrl({
    String id,
    String token,
    String userId,
  }) {
    return _appendDotJsonAndToken('$_orders/$userId/$id', token);
  }

  static String getUserFavoriteProductUrl({
    String userId,
    String productId,
    String token,
  }) {
    final baseUrl = '$_apiHost/userFavorites/$userId';
    return _appendDotJsonAndToken(
      productId == null ? baseUrl : '$baseUrl/$productId',
      token,
    );
  }

  static String getIdentityUrl(AuthMode mode) {
    final authMode = mode == AuthMode.Signup ? 'signUp' : 'signInWithPassword';
    return 'https://identitytoolkit.googleapis.com/v1/accounts:$authMode?key=$_apiKey';
  }

  static String _appendDotJsonAndToken(String url, String token) =>
      '$url.json?auth=$token';
}
