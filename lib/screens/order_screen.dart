import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item_card.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/OrderScreen";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          SizedBox(height: 8),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<Orders>(context, listen: false)
                  .fetchAndSetOrders(),
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Consumer<Orders>(
                          builder: (context, value, child) =>
                              value.items.length <= 0
                                  ? Center(
                                      child: Text('There is no order items..'),
                                    )
                                  : ListView.builder(
                                      itemCount: value.items.length,
                                      itemBuilder: (_, i) => OrderItemCard(
                                        order: value.items[i],
                                      ),
                                    ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
