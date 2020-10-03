import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item_card.dart';

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
          ...[Card(), Card()],
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FlatButton(
                          child: Text('Order Now'),
                          onPressed: () {
                            context.read<Orders>().addOrder(cart.itemList);
                            cart.clearCarts();
                            Navigator.of(context).pop();
                          },
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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
