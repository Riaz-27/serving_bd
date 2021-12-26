import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/providers/cart.dart';
import 'package:intl/intl.dart';
import 'package:serving_bd/screens/checkout_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();

  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;
  DateTime date = DateTime.now();
  DateTime _date = DateTime.now();
  var user;
  @override
  Widget build(BuildContext context) {
    //getting user info
    user = context.read<Auth>().userData;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      floatingActionButton: buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        const Text(
                          'When would you like your service?',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 8,
                            itemBuilder: (_, index) {
                              return buildDateTimeBox(
                                index: index,
                                width: 70.0,
                                seletedIndex: _selectedDateIndex,
                                date: date,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 110,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        const Text(
                          'At what time should the Service Provider arrive?',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 15,
                            itemBuilder: (_, index) {
                              date = DateTime(
                                  date.year, date.month, date.day, 7, 0, 0);
                              return buildDateTimeBox(
                                index: index,
                                width: 130.0,
                                seletedIndex: _selectedTimeIndex,
                                isTimeBox: true,
                                date: date,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        const Text(
                          'Order For?',
                          textAlign: TextAlign.center,
                        ),
                        Form(
                          key: _formkey,
                          child: Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        initialValue: user['name'],
                                        decoration: const InputDecoration(
                                          labelText: "Name",
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(8),
                                        ),
                                        keyboardType: TextInputType.name,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Invalid name';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          user['name'] = value!;
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        initialValue: user['mobile'],
                                        decoration: const InputDecoration(
                                          labelText: 'Mobile',
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(8),
                                        ),
                                        keyboardType: TextInputType.name,
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              value.length < 11) {
                                            return 'Invalid number';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          user['mobile'] = value!;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    initialValue: user['address'],
                                    decoration: const InputDecoration(
                                      labelText: 'Address',
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                    keyboardType: TextInputType.name,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 11) {
                                        return 'Invalid number';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      user['address'] = value!;
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateTimeBox({
    required int index,
    required width,
    required int seletedIndex,
    required DateTime date,
    bool isTimeBox = false,
  }) {
    const color1 = Color.fromRGBO(198, 31, 98, 1);
    const color2 = Color.fromRGBO(55, 54, 86, 1);
    const color3 = Color.fromRGBO(253, 244, 249, 1);

    var isActive = seletedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isTimeBox) {
            _selectedTimeIndex = index;
          } else {
            _selectedDateIndex = index;
            _selectedTimeIndex = 0;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            border: Border.all(color: isActive ? color1 : Colors.grey),
            borderRadius: BorderRadius.circular(10),
            color: isActive ? color3 : Colors.white,
          ),
          child: isTimeBox
              ? showTime(
                  date.add(
                    Duration(hours: index, days: _selectedDateIndex),
                  ),
                )
              : showDate(
                  date.add(
                    Duration(days: index),
                  ),
                ),
        ),
      ),
    );
  }

  Widget showDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(DateFormat('EEE').format(date).toUpperCase()),
        const SizedBox(
          height: 10,
        ),
        Text(day),
      ],
    );
  }

  Widget? showTime(DateTime date) {
    if (date.hour > 21 || date.hour < 7) {
      return null;
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('${DateFormat('h a').format(date)} - ${DateFormat('h a').format(
            date.add(Duration(hours: 1)),
          )}'),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formkey.currentState!.validate()) {
      return;
    }
    _date = date.add(Duration(days: _selectedDateIndex));
    _date = DateTime(
        _date.year, _date.month, _date.day, 7 + _selectedTimeIndex, 0, 0);
    if (_date.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Invalid Time: selected time is not valid",
          style: TextStyle(color: Colors.red),
        ),
        duration: Duration(seconds: 3),
      ));
      return;
    }
    _formkey.currentState!.save();

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) {
        return CheckoutScreen(userData: user, dateTime: _date);
      }),
    );
  }

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
            onTap: _submit,
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
                    "Checkout",
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
}
