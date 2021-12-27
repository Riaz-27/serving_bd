import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/providers/orders.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders-page';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final color1 = const Color.fromRGBO(198, 31, 98, 1);
  final color2 = const Color.fromRGBO(55, 54, 86, 1);

  int _selectedIndex = 0;
  var _isLoading = true;
  var _orders = [];
  var userId = '';
  var authToken = '';
  DateTime dateTime = DateTime.now();
  var filtedOrders = [];
  // print((_orders[2]['services'][0]['serviceName']));

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    userId = context.read<Auth>().userId;
    authToken = context.read<Auth>().token!;
    context.read<Orders>().fetchAndSetOrders(userId, authToken).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _orders = context.read<Orders>().orders;
    var filtedOrders = _orders;
    if (_selectedIndex == 0) {
      filtedOrders.removeWhere(
        (item) => item['orderStatus'].toString().contains('Completed'),
      );
    } else {
      filtedOrders.removeWhere(
        (item) => !item['orderStatus'].toString().contains('Completed'),
      );
    }

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildTopNav(0, "On Going"),
                      ),
                      Expanded(
                        flex: 1,
                        child: buildTopNav(1, "Recent Orders"),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtedOrders.length,
                      itemBuilder: (_, index) {
                        return _buildOrdersList(
                          index: index,
                          orders: filtedOrders,
                        );
                      },
                    ),
                  ),
                ],
              ),
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

  Widget _buildOrdersList({
    required int index,
    required List<dynamic> orders,
  }) {
    dateTime = DateTime.parse(orders[index]['dateTime'].toString());

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orders[index]['services'][0]['serviceName'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: 40,
                  width: 200,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount:
                              (orders[index]['services'] as List<dynamic>)
                                  .length,
                          itemBuilder: (_, ind) {
                            return Text(
                              ' ' +
                                  orders[index]['services'][ind]['subCatTitle'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              softWrap: false,
                              overflow: TextOverflow.visible,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  DateFormat('dd, MMM yyyy · hh:mm a')
                      .format(dateTime)
                      .toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  width: 80,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: const Color(0xFF489D53),
                  ),
                  child: Center(
                    child: Text(
                      orders[index]['orderStatus'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "৳  ${orders[index]['totalAmount']}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
