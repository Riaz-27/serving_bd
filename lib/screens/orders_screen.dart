import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/providers/orders.dart';

import '../widgets/orders_processing.dart';
import '../widgets/orders_recent.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders-page';

  OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final color1 = const Color.fromRGBO(198, 31, 98, 1);
  final color2 = const Color.fromRGBO(55, 54, 86, 1);

  int _selectedIndex = 1;
  var _isLoading = true;
  var _orders = [];
  var userId = '';
  var authToken = '';

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    userId = context.read<Auth>().userId;
    authToken = context.read<Auth>().token!;
    context.read<Orders>().fetchAndSetOrders(userId, authToken).then((_) {
      _orders = context.read<Orders>().orders;
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widgetsList = [
      OrdersProcessing(
        orders: _orders,
      ),
      OrdersRecent(orders: _orders,),
    ];

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: buildTopNav(0, "Processing"),
                    ),
                    Expanded(
                      flex: 1,
                      child: buildTopNav(1, "Recent Orders"),
                    ),
                  ],
                ),
                widgetsList[_selectedIndex],
              ],
            ),
          );
  }

  Widget buildTopNav(int index, String text) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 45,
        child: Card(
          color: isActive ? color1 : Colors.white,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
                color: isActive ? Colors.white : color2,
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
