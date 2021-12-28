import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/providers/orders.dart';
import 'package:serving_bd/screens/service_provider/order_list_screen.dart';
import 'package:serving_bd/screens/service_provider/provider_profile_screen.dart';
import 'package:serving_bd/widgets/service_provider.dart/provider_app_drawer.dart';

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({Key? key}) : super(key: key);

  @override
  _ServiceProviderScreenState createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _allOrders = [];
  List<Map<String, dynamic>> _currentOrder = [];
  List<Map<String, dynamic>> _availableOrders = [];
  List<Map<String, dynamic>> _completeOrders = [];
  var userData;
  var token;

  var _isLoading = true;

  @override
  void initState() {
    _isLoading = true;
    token = context.read<Auth>().token;
    context.read<Orders>().fetchAllOrders(token!).then((_) {
      userData = context.read<Auth>().userData;
      _allOrders = context.read<Orders>().allOrders;
      // _currentOrder = _allOrders;
      // _availableOrders = _allOrders;
      // _completeOrders = _allOrders;

      for (var item in _allOrders) {
        String providerUserId = item['providerUserId'];
        String status = item['orderStatus'];

        if (providerUserId == userData['userId'] && !(status == 'Completed')) {
          print('Found current');
          _currentOrder.add(item);
        }

        String orderType = item['orderType'];
        String serviceType = userData['serviceType'];
        if (providerUserId == 'NA' && orderType == serviceType) {
          print('Found available');
          _availableOrders.add(item);
        }

        if (providerUserId == userData['userId'] && status == 'Completed') {
          print('Found complete');
          _completeOrders.add(item);
        }
      }

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var dateTime = DateTime.now();

    Widget _buildOrdersList({
      required int index,
      required List<dynamic> orders,
    }) {
      if (orders.length == 0) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "No Current Job",
                  softWrap: true,
                  style: TextStyle(fontSize: 16, color: Colors.red.shade400),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Not Currently Working. Take an available job to continue!",
                  softWrap: true,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }

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
                                    orders[index]['services'][ind]
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
                  Text(
                    'Mobile : ${orders[index]['customerMobile'].toString().padLeft(12, "+88")}',
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
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      context
                          .read<Orders>()
                          .completeOrder(order: orders[index], authToken: token)
                          .then(
                            (_) => context
                                .read<Auth>()
                                .updateEarning(orders[index]['totalAmount'])
                                .then(
                                  (__) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return ServiceProviderScreen();
                                      },
                                    ),
                                  ),
                                ),
                          );
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
                            'Mark Complete',
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

    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : (userData['NID'] == "NA" || userData['NID'].toString().length != 10)
            ? const ProviderProfileScreen()
            : Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  title: const Text('Service Provider'),
                  leading: GestureDetector(
                    onTap: () => _scaffoldKey.currentState!.openDrawer(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(
                              userData['profilePic'].toString(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                drawer: ProviderAppDrawer(
                  userData: userData,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Balance Status",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 100,
                              width: deviceWidth / 2 - 10,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Orders Served",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        _completeOrders.length.toString(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              width: deviceWidth / 2 - 10,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Total Earning",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "৳ ${userData['totalEarning'].toString()}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Order Status",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildOrdersList(index: 0, orders: _currentOrder),
                        SizedBox(
                          height: 130,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return OrderListScreen(
                                              title: 'Avaiable Orders',
                                              orders: _availableOrders,
                                              available:
                                                  _currentOrder.length > 0
                                                      ? false
                                                      : true,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: buildTitle(
                                        title: 'Available Orders',
                                        count: _availableOrders.length)),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return OrderListScreen(
                                              title: 'Completed Orders',
                                              orders: _completeOrders,
                                              isComplete: false,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: buildTitle(
                                        title: 'Completed Orders',
                                        count: _completeOrders.length)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
  }

  Widget buildTitle({
    required title,
    required count,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
