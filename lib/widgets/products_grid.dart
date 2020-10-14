import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool isShowFavoriteOnly;

  ProductsGrid({
    @required this.isShowFavoriteOnly,
  });

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    final productsFiltered =
        isShowFavoriteOnly ? products.favoriteItems : products.items;

    if (productsFiltered.isEmpty) {
      return Center(
        child: Text(
          products.items.isEmpty
              ? 'There\'s no products'
              : 'There\'s no favorite products. \n Start adding some!',
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: productsFiltered.length,

      // add changeNotifierProvider here to passing product data.
      // the passed data would become reactive when the data change-
      // it would automatically rebuild the widget.

      // with the ChangeNotifierProvider.value constructor we can-
      // actually make sure provider works even if data changes for the widgets
      // because now provider attached to its data..
      // when using ChangeNotifierProvider(create: (ctx) => ...) inside grid or -
      // list it would cause bugs as soon as you have more items because -
      // the way of widget recycled
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: productsFiltered[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
    );
  }
}
