import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/utilities/dialogs.dart';
import 'package:shop_app/widgets/app_bar_cart_badge.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOption { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  static const String routeName = "/productOverview";

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isShowFavoriteOnly = false;
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    context
        .read<Products>()
        .fetchAndSetProducts()
        .whenComplete(() => setState(() => _isLoading = false))
        .catchError(
      (error) {
        print(error);
        return Dialogs.showAlertDialog(
          context: context,
          message: (error is HttpException)
              ? error.message
              : 'an unknown error occurred',
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton<FilterOption>(
            icon: Icon(Icons.more_vert),
            onSelected: (selectedVal) {
              setState(() {
                _isShowFavoriteOnly = selectedVal == FilterOption.Favorites;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOption.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOption.All,
              )
            ],
          ),
          AppBarCartBadge()
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(
              isShowFavoriteOnly: _isShowFavoriteOnly,
            ),
    );
  }
}
