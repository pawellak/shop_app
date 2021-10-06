import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOption { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          buildPopupMenuButton(),
          buildCart(context)
        ],
      ),
      body: ProductsGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }

  Consumer<Cart> buildCart(BuildContext context) {
    return Consumer<Cart>(
          builder: (_, cart, ch) => Badge(
            value: cart.itemCount.toString(),
            child: ch!,
          ),
          child: IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
        );
  }

  PopupMenuButton<FilterOption> buildPopupMenuButton() {
    return PopupMenuButton(
          onSelected: (FilterOption selectedValue) {
            setState(() {
              if (selectedValue == FilterOption.favorites) {
                _showOnlyFavorites = true;
              } else {
                _showOnlyFavorites = false;
              }
            });
          },
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            const PopupMenuItem(
              child: Text('Only Favorites'),
              value: FilterOption.favorites,
            ),
            const PopupMenuItem(
              child: Text('Show All'),
              value: FilterOption.all,
            ),
          ],
        );
  }
}
