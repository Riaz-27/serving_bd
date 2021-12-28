import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/providers/orders.dart';
import 'package:serving_bd/screens/service_provider/service_provider_screen.dart';

class OrderListScreen extends StatefulWidget {
  final orders;
  final title;
  final available;
  final isComplete;

  const OrderListScreen({
    Key? key,
    this.orders,
    this.title,
    this.available = true,
    this.isComplete = true,
  }) : super(key: key);

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  var dateTime = DateTime.now();

  var userData;
  var authToken;

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
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
                Text(
                  orders[index]['paymentType'].toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                  ),
                ),
                Text(
                  'Address : ${orders[index]['customerAddress'].toString()}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    color: const Color(0xFF489D53),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
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
                ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isComplete)
                  GestureDetector(
                    onTap: () {
                      if (!widget.available) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Already on a job'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      context
                          .read<Orders>()
                          .updateProvider(
                            providerDetails: userData,
                            authToken: authToken,
                            order: orders[index],
                          )
                          .then((_) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) {
                              return ServiceProviderScreen();
                            },
                          ),
                        );
                      });
                    },
                    child: Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        color: const Color(0xFF489D53),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Text(
                            'Take Order',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    userData = context.read<Auth>().userData;
    authToken = context.read<Auth>().token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.orders.length,
                itemBuilder: (_, index) {
                  return _buildOrdersList(
                    index: index,
                    orders: widget.orders,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
