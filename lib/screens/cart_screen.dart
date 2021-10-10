import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your cart'),
        ),
        body: Column(children: [
          summaryOfCart(context, cart),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, i) => CartItem(
                      id: cart.items.values.toList()[i].id,
                      price: cart.items.values.toList()[i].price,
                      quantity: cart.items.values.toList()[i].quantity,
                      title: cart.items.values.toList()[i].title,
                      productId: cart.items.keys.toList()[i],
                    )),
          ),
        ]));
  }

  Card summaryOfCart(BuildContext context, Cart cart) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total', style: TextStyle(fontSize: 20)),
            const Spacer(),
            Chip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Text('\$${cart.totalAmount.toStringAsFixed(2)}'),
            ),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Provider.of<Orders>(context, listen: false)
                    .addOrders(cart.items.values.toList(), cart.totalAmount);
                cart.clear();
              },
              child: const Text('Order now', style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
      margin: const EdgeInsets.all(15),
    );
  }
}
