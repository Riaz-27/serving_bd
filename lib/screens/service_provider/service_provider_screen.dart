import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/providers/orders.dart';
import 'package:serving_bd/widgets/service_provider.dart/provider_app_drawer.dart';

class ServiceProviderScreen extends StatefulWidget {
  const ServiceProviderScreen({Key? key}) : super(key: key);

  @override
  _ServiceProviderScreenState createState() => _ServiceProviderScreenState();
}

class _ServiceProviderScreenState extends State<ServiceProviderScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>>? allOrders;
  List<Map<String, dynamic>>? currentOrder;
  List<Map<String, dynamic>>? availableOrders;
  List<Map<String, dynamic>>? completeOrders;


  var _isLoading = true;

  @override
  void initState() {
    var token = context.read<Auth>().token;
    _isLoading = true;
    context.read<Orders>().fetchAllOrders(token!).then((_) {
      allOrders = context.read<Orders>().allOrders;
      currentOrder = allOrders;
      availableOrders = allOrders;
      completeOrders = allOrders;

      currentOrder!.removeWhere((order) => order['']);
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = context.read<Auth>().userData;

    var deviceWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Scaffold(
          body: Center(
              child: CircularProgressIndicator(),
            ),
        )
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
                                children: const [
                                  Padding(
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
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "৳  4,500",
                                    style: TextStyle(
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
                                    "৳ ${userData['totalEarning']}",
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
                        "Job Status",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    buildTitle(title: 'Current Jobs'),
                    buildTitle(title: 'Available Jobs'),
                    buildTitle(title: 'Completed Jobs'),
                  ],
                ),
              ),
            ),
          );
  }

  Widget buildTitle({
    required title,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 30,
                    color: Color(0xFFC61F62),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
