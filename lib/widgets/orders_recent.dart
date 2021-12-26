import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersRecent extends StatefulWidget {
  final List<dynamic> orders;

  const OrdersRecent({Key? key, required this.orders}) : super(key: key);

  @override
  State<OrdersRecent> createState() => _OrdersRecentState();
}

class _OrdersRecentState extends State<OrdersRecent> {
  @override
  Widget build(BuildContext context) {
    print((widget.orders[2]['services'][0]['serviceName']));

    widget.orders.removeWhere(
      (item) => !item['orderStatus'].toString().contains('completed'),
    );

    DateTime dateTime = DateTime.now();

    Widget _buildOrdersList({
      required int index,
    }) {
      dateTime = DateTime.parse(widget.orders[index]['dateTime'].toString());

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
                    widget.orders[index]['services'][0]['serviceName'],
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
                            itemCount: (widget.orders[index]['services']
                                    as List<dynamic>)
                                .length,
                            itemBuilder: (_, ind) {
                              return Text(
                                ' ' +
                                    widget.orders[index]['services'][ind]
                                        ['subCatTitle'],
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
                        widget.orders[index]['orderStatus'],
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
                    "৳  ${widget.orders[index]['totalAmount']}",
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

    return Expanded(
      child: ListView.builder(
        itemCount: widget.orders.length,
        itemBuilder: (_, index) {
          return _buildOrdersList(
            index: index,
          );
        },
      ),
    );
  }
}
