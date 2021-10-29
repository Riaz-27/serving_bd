import 'package:flutter/material.dart';

import '../widgets/orders_on_cart.dart';
import '../widgets/orders_processing.dart';
import '../widgets/orders_recent.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders-page';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final color1 = Color.fromRGBO(198, 31, 98, 1);
  final color2 = Color.fromRGBO(55, 54, 86, 1);

  int _selectedIndex = 0;

  final widgetsList = [
    OrdersOnCart(),
    OrdersProcessing(),
    OrdersRecent(),
  ];

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTopNav(0, "On Cart"),
                buildTopNav(1, "Processing"),
                buildTopNav(2, "Recent Orders"),
              ],
            ),
          ),
          widgetsList[_selectedIndex],
        ],
      ),
    );
  }

  Widget buildTopNav(int index, String text) {
    final isActive = _selectedIndex == index;
    return InkWell(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 45,
        width: 110,
        child: InkWell(
          child: Card(
            elevation: 4,
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
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
