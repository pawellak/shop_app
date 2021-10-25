import 'package:flutter/material.dart';
import 'package:shop_app/providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 150, 200) : 130,
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
                title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: _expanded
                      ? const Icon(Icons.expand_less)
                      : const Icon(Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dataTime),
                )),
            AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(10),
                height: _expanded? min(widget.order.products.length * 20.0 + 15, 100):0,
                child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(prod.title),
                              Text(
                                '${prod.quantity}x \$${prod.price}',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.pink),
                              )
                            ],
                          ))
                      .toList(),
                )),
          ],
        ),
      ),
    );
  }
}
