import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/carts.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(),
          update: (_, auth, prevState) => Products(
            authToken: auth.token,
            userId: auth.userId,
            prevState: prevState,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(),
          update: (_, auth, prevState) => Orders(
            authToken: auth.token,
            userId: auth.userId,
            prevState: prevState,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => Carts(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          final authScreen = AuthScreen();
          final productOverviewScreen = ProductOverviewScreen();
          return MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.orange,
              canvasColor: Color.fromRGBO(237, 235, 240, 1),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Lato',
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(),
              ),
            ),
            home: auth.isAuthenticated
                ? productOverviewScreen
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : authScreen,
                  ),
            routes: {
              AuthScreen.routeName: (_) => authScreen,
              ProductOverviewScreen.routeName: (_) => productOverviewScreen,
              ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
              CartScreen.routeName: (_) => CartScreen(),
              OrderScreen.routeName: (_) => OrderScreen(),
              UserProductScreen.routeName: (_) => UserProductScreen(),
              EditProductScreen.routeName: (_) => EditProductScreen()
            },
          );
        },
      ),
    );
  }
}
