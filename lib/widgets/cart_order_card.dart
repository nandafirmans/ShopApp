import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/utilities/dialogs.dart';

class CartOrderCard extends StatefulWidget {
  @override
  _CartOrderCardState createState() => _CartOrderCardState();
}

class _CartOrderCardState extends State<CartOrderCard> {
  bool _isLoading = false;

  void _saveOrder(BuildContext context, Carts cart) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<Orders>().addOrder(cart.itemList);
    } catch (error) {
      Dialogs.showAlertDialog(
        context: context,
        title: 'An unknown error occurred',
        message: 'Failed to adding orders',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      cart.clearCarts();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Carts>();
    return Card(
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
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : const Text('Order Now'),
                    onPressed: cart.totalAmount <= 0 || _isLoading
                        ? null
                        : () => _saveOrder(context, cart),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
