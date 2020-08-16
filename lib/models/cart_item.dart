import 'package:shop_app/providers/product.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    this.id,
    this.title,
    this.price,
    this.quantity,
  });

  double get totalPrice {
    return price * quantity;
  }
}
