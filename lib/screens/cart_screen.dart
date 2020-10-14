import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/widgets/cart_item_card.dart';
import 'package:shop_app/widgets/cart_order_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Carts>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          CartOrderCard(),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemList.length,
              itemBuilder: (_, i) => CartItemCard(
                id: cart.itemList[i].id,
                price: cart.itemList[i].price,
                quantity: cart.itemList[i].quantity,
                title: cart.itemList[i].title,
                productId: cart.itemKeys[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}
