import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_card.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/OrderScreen";

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<Orders>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: orders.items.length,
              itemBuilder: (_, i) => OrderItemCard(
                order: orders.items[i],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
