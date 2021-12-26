import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/cart.dart';

class CheckoutScreen extends StatelessWidget {
  final Map<String, dynamic> userData;
  final DateTime dateTime;
  const CheckoutScreen(
      {Key? key, required this.userData, required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const color1 = Color.fromRGBO(198, 31, 98, 1);

    String a = dateTime.hour > 12 ? 'PM' : 'AM';
    int initHour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;

    final _items = context.read<Cart>().items;

    List<Widget> wid = [];
    _items.forEach((_, item) {
      var serviceName = item.serviceName;
      var subCatTitle = item.subCatTitle;
      var quantity = item.quantity;
      var price = item.price;
      wid.add(
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              serviceName,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$subCatTitle   x$quantity',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  ' ${price * quantity}',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });

    Widget buildFloatingActionButton() {
      final deviceSize = MediaQuery.of(context).size;
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              // elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: 40,
                width: (deviceSize.width / 2) - 10,
                child: Center(
                  child: Text(
                    "Total ৳ ${context.watch<Cart>().totalAmount}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Card(
                // elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: const Color(0xFFC61F62),
                child: SizedBox(
                  height: 40,
                  width: (deviceSize.width / 2) - 50,
                  child: const Center(
                    child: Text(
                      "Place Order",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.date_range_rounded,
                              color: color1,
                              size: 20,
                            ),
                            Text(
                              ' SCHEDULE',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Schedule Date",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat("dd").format(dateTime),
                                        style: TextStyle(fontSize: 26),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        DateFormat("MMM yyyy \nEEEEEEEEEE")
                                            .format(dateTime),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const VerticalDivider(
                                width: 50,
                                thickness: 3,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Schedule Time",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${initHour} - ${initHour + 1}',
                                        style: TextStyle(fontSize: 26),
                                      ),
                                      Text(
                                        '  $a',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.location_on,
                              color: color1,
                              size: 20,
                            ),
                            Text(
                              ' ORDERED FOR',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                userData['name'],
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              const VerticalDivider(
                                width: 20,
                                thickness: 3,
                              ),
                              Text(
                                userData['mobile']
                                    .toString()
                                    .padLeft(12, '+88'),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          userData['address'],
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.settings,
                              color: color1,
                              size: 20,
                            ),
                            Text(
                              ' BILL',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                            itemCount: _items.length,
                            itemBuilder: (_, index) {
                              return wid[index];
                            },
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Amount to be paid"),
                            Text('${context.read<Cart>().totalAmount}')
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
