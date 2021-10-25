import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers(),
      child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'MyShop ',
                theme: buildThemeData(),
                home: auth.isAuth
                    ? const ProductsOverviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const AuthScreen(),
                      ),
                routes: routes(),
              )),
    );
  }

  List<SingleChildWidget> providers() {
    return [
      ChangeNotifierProvider(create: (ctx) => Auth()),
      ChangeNotifierProxyProvider<Auth, Products>(
        create: (_) => Products('', '', []),
        update: (ctx, auth, previousProducts) {
          if (auth.isAuth == false) return Products('', '', []);
          return Products(auth.token!, auth.userId, previousProducts!.items);
        },
      ),
      ChangeNotifierProvider(create: (ctx) => Cart()),
      ChangeNotifierProxyProvider<Auth, Orders>(
        create: (_) => Orders('', '', []),
        update: (ctx, auth, previousProducts) {
          if (auth.token == null) return Orders('', '', []);
          return Orders(auth.token!, auth.userId, previousProducts!.orders);
        },
      )
    ];
  }

  ThemeData buildThemeData() {
    return ThemeData(
        fontFamily: 'Lato',
        pageTransitionsTheme: PageTransitionsTheme(
            builders: {TargetPlatform.android: CustomPageTransitionBuilder()}),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.deepOrange));
  }

  Map<String, WidgetBuilder> routes() {
    return {
      ProductsOverviewScreen.routeName: (context) =>
          const ProductsOverviewScreen(),
      ProductDetailScreen.routeName: (context) => const ProductDetailScreen(),
      CartScreen.routeName: (context) => const CartScreen(),
      OrdersScreen.routeName: (context) => const OrdersScreen(),
      UserProductsScreen.routeName: (context) => const UserProductsScreen(),
      EditProductScreen.routeName: (context) => const EditProductScreen(),
      AuthScreen.routeName: (context) => const AuthScreen()
    };
  }
}
