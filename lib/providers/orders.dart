import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items => [..._items];

  void addOrder(List<CartItem> cartProducts) {
    final now = DateTime.now();
    final total = cartProducts.fold<double>(
      0,
      (prevVal, p) => prevVal += p.totalPrice,
    );

    _items.insert(
      _items.length,
      OrderItem(
        id: now.toString(),
        dateTime: now,
        amount: total,
        products: cartProducts,
      ),
    );
  }
}
