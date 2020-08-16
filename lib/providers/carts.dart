import 'package:flutter/foundation.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/providers/product.dart';

class Carts with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  List<CartItem> get itemList => _items.values.toList();
  List<String> get itemKeys => _items.keys.toList();

  int get itemsLength => _items?.length ?? 0;

  double get totalAmount {
    var result = 0.0;
    _items.forEach((key, value) {
      result += value.totalPrice;
    });
    return result;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (currentCart) => CartItem(
          id: currentCart.id,
          price: currentCart.price,
          title: currentCart.title,
          quantity: currentCart.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          id: DateTime.now().toIso8601String(),
          price: product.price,
          title: product.title,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCarts() {
    _items = {};
    notifyListeners();
  }
}
