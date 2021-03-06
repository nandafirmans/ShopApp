import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem order;

  OrderItemCard({this.order});

  @override
  _OrderItemCardState createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard>
    with SingleTickerProviderStateMixin {
  var _isExpanded = false;

  Widget _buildProductList(CartItem p) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              p.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${p.quantity}x \$${p.totalPrice}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 8,
      ),
      child: InkWell(
        onTap: () => setState(() {
          _isExpanded = !_isExpanded;
        }),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                transform: _isExpanded
                    ? (Matrix4.rotationX(9.6)..translate(0.0, -20.0))
                    : Matrix4.identity(),
                child: const Icon(Icons.expand_more),
              ),
            ),
            AnimatedSize(
              vsync: this,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn,
              child: Container(
                child: _isExpanded
                    ? Column(
                        children: widget.order.products
                            .map(_buildProductList)
                            .toList(),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
