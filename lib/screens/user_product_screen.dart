import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/product";

  Future<void> _fetchAndSetProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(
      isFilterByUser: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
              );
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _fetchAndSetProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _fetchAndSetProducts(context),
                    child: Consumer<Products>(
                      builder: (context, products, _) => ListView.builder(
                        padding: EdgeInsets.all(15),
                        itemCount: products.items.length,
                        itemBuilder: (_, i) => UserProductItem(
                          key: ValueKey(products.items[i].id),
                          productId: products.items[i].id,
                          title: products.items[i].title,
                          imageUrl: products.items[i].imageUrl,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
