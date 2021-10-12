import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop ',
        theme: buildThemeData(),
        home: const ProductsOverviewScreen(),
        routes: routes(),
      ),
    );
  }

  List<SingleChildWidget> providers() {
    return [
      ChangeNotifierProvider(create: (ctx) => Products()),
      ChangeNotifierProvider(create: (ctx) => Cart()),
      ChangeNotifierProvider(create: (ctx) => Orders())
    ];
  }

  ThemeData buildThemeData() {
    return ThemeData(
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.deepOrange));
  }

  Map<String, WidgetBuilder> routes() {
    return {
      ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
      CartScreen.routeName: (context) => const CartScreen(),
      OrdersScreen.routeName: (context) => const OrdersScreen(),
      UserProductsScreen.routeName: (context) => const UserProductsScreen(),
      EditProductScreen.routeName: (context) => const EditProductScreen(),
    };
  }
}
