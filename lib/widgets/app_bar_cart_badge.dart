import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';

class AppBarCartBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final carts = context.watch<Carts>();

    return Badge(
      value: carts.itemsLength.toString(),
      child: IconButton(
        icon: Icon(Icons.shopping_cart),
        onPressed: () {
          if (carts.itemsLength > 0) {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('There\'s no items in cart'),
              ),
            );
          }
        },
      ),
    );
  }
}
