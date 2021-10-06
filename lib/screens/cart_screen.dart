import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your cart'),
        ),
        body: Column(children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontSize: 20)),
                  const Spacer()  ,
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    label: Text('\$${cart.totalAmount}'),
                  ),
                  TextButton(
                    onPressed: () {},
                    child:
                        const Text('Order now', style: TextStyle(fontSize: 20)),
                  )
                ],
              ),
            ),
            margin: const EdgeInsets.all(15),
          )
        ]));
  }
}
