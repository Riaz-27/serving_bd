import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/main.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/providers/cart.dart';
import 'package:serving_bd/providers/orders.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var _selectedIndex = -1;

  final controller = TextEditingController();

  @override
  void dispose() {
    controller;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color1 = Color.fromRGBO(198, 31, 98, 1);
    const color2 = Color.fromRGBO(55, 54, 86, 1);
    const color3 = Color.fromRGBO(253, 244, 249, 1);

    var userId = context.read<Auth>().userId;
    var authToken = context.read<Auth>().token;
    var orderId = context.read<Orders>().orderId;
    var reference = orderId.substring(orderId.length - 6);

    Widget homeButton() {
      return GestureDetector(
        onTap: () {
          context.read<Cart>().clear();
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
            return MainPage();
          }));
        },
        child: const Icon(
          Icons.home,
          color: color1,
        ),
      );
    }

    List<String> types = [
      'bkash',
      'rocket',
      'nagad',
    ];

    Widget paymentWidget({
      required String img,
      required String text,
      required int index,
    }) {
      var isActive = _selectedIndex == index;
      return GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: isActive ? color1 : Colors.grey),
                color: isActive ? color3 : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.network(img),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(text),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: GestureDetector(
          onTap: () {},
          child: homeButton(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://firebasestorage.googleapis.com/v0/b/serving-bd-2.appspot.com/o/log.png?alt=media&token=b4ae4ff4-475a-4c79-9231-41d3ef8b19dd'),
                        radius: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Order placed successfully',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'A service provider will be assigned to your order \nbefore 1 hour of your schedule time',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            softWrap: true,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'PAYMENT OPTIONS',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        softWrap: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Your order is currently confirmed as pay with cash. You can also pay now by using following payment options',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        softWrap: true,
                      ),
                      paymentWidget(
                        img:
                            'https://firebasestorage.googleapis.com/v0/b/serving-bd-2.appspot.com/o/logo-bn.png?alt=media&token=6031a275-0462-481b-a349-e7f92984d763',
                        text: "Pay through bKash",
                        index: 0,
                      ),
                      paymentWidget(
                        img:
                            'https://firebasestorage.googleapis.com/v0/b/serving-bd-2.appspot.com/o/mlogo.png?alt=media&token=9715bd78-f3fb-4521-9c8e-a69dea53f56c',
                        text: "Pay through Rocket",
                        index: 1,
                      ),
                      paymentWidget(
                        img:
                            'https://firebasestorage.googleapis.com/v0/b/serving-bd-2.appspot.com/o/nagad.png?alt=media&token=2cdb0916-33b3-4a1d-acac-62007fd5b88a',
                        text: "Pay through Nagad",
                        index: 2,
                      ),
                    ],
                  ),
                ),
              ),
              if (_selectedIndex > -1)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'PAYMENT DETAILS',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Use the follwing details during payment.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Merchant no ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          '+8801812345678',
                          style: TextStyle(fontSize: 14),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Reference no ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          reference,
                          style: const TextStyle(fontSize: 14),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Amount to pay ',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          context.read<Cart>().totalAmount.toString(),
                          style: const TextStyle(fontSize: 14),
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: controller,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            isDense: true,
                            label: Text(
                              'Enter TxID',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (controller.text.isEmpty ||
                                controller.text.length < 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Invalid TxID: Make sure to enter a valid TxID",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                              return;
                            }
                            context.read<Orders>().updatePayment(
                                  type: types[_selectedIndex],
                                  userId: userId,
                                  authToken: authToken!,
                                  orderId: orderId,
                                  txid: controller.text,
                                  paymentStatus: 'paid',
                                );
                            context.read<Cart>().clear();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) {
                                return MainPage();
                              }),
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: const Color(0xFFC61F62),
                            child: const SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "Confirm Payment",
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
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
