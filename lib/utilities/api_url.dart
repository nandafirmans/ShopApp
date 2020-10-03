class ApiUrl {
  static const _apiHost = 'https://flutter-shop-app-44b4c.firebaseio.com';
  static const products = '$_apiHost/products.json';
  static const orders = '$_apiHost/orders.json';

  static String product(String id) => _insertId(products, id);

  static String order(String id) => _insertId(orders, id);

  static String _insertId(String basePath, String id) {
    final dotJsonIndex = basePath.lastIndexOf('.json');
    return basePath.substring(0, dotJsonIndex) +
        id +
        basePath.substring(dotJsonIndex);
  }
}
