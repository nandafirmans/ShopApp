import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:shop_app/models/order_item.dart';
import 'package:shop_app/utilities/api_url.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items => [..._items];

  Future<void> fetchAndSetOrders() async {
    final response = await get(ApiUrl.orders);
    final Map<String, dynamic> responseBody = json.decode(response.body);
    final List<OrderItem> results = responseBody == null
        ? []
        : responseBody.entries
            .map((orderItem) => OrderItem(
                  id: orderItem.key,
                  amount: orderItem.value['amount'],
                  dateTime: DateTime.parse(orderItem.value['dateTime']),
                  products: (orderItem.value['products'] as List<dynamic>)
                      .map((product) => CartItem(
                            id: product['id'],
                            title: product['title'],
                            price: product['price'],
                            quantity: product['quantity'],
                          ))
                      .toList(),
                ))
            .toList();
    results.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    _items = results;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts) async {
    final timeStamp = DateTime.now();
    final total = cartProducts.fold<double>(
      0,
      (prevVal, p) => prevVal += p.totalPrice,
    );
    final body = json.encode({
      'dateTime': timeStamp.toIso8601String(),
      'amount': total,
      'products': cartProducts
          .map(
            (cp) => {
              'id': cp.id,
              'title': cp.title,
              'quantity': cp.quantity,
              'price': cp.price,
            },
          )
          .toList(),
    });
    final response = await post(ApiUrl.orders, body: body);

    if (response.statusCode >= 400) {
      throw HttpException('Can\'t adding orders');
    }

    final responseBody = json.decode(response.body);
    final orderItem = OrderItem(
      id: responseBody['name'],
      dateTime: timeStamp,
      amount: total,
      products: cartProducts,
    );

    _items.add(orderItem);
    notifyListeners();
  }
}
