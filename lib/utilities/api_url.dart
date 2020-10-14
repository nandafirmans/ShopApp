class ApiUrl {
  static const _apiHost = 'https://flutter-shop-app-44b4c.firebaseio.com';
  static const _products = '$_apiHost/products';
  static const _orders = '$_apiHost/orders';

  static String get products {
    return _appendDotJson(_products);
  }

  static String get orders {
    return _appendDotJson(_orders);
  }

  static String product(String id) => _appendDotJson('$_products/$id');

  static String order(String id) => _appendDotJson('$_orders/$id');

  static String _appendDotJson(String url) => '$url.json';
}
