import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:serving_bd/providers/cart.dart';

class Orders with ChangeNotifier {
  List<Map<String, dynamic>> _orders = [];

  String _orderId = '';

  List<Map<String, dynamic>>  get orders {
    return [..._orders];
  }

  String get orderId {
    return _orderId;
  }

  Future<void> fetchAndSetOrders(String userId, String authToken) async {
    try {
      var url = Uri.parse(
          'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
      final response = await http.get(url);
      final List<Map<String, dynamic>> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach(
        (orderId, orderData) {
          loadedOrders.add(
            {
              'customerName': orderData['customerName'],
              'customerMobile': orderData['customerMobile'],
              'dateTime': DateTime.parse(orderData['dateTime']),
              'services': (orderData['services'] as List<dynamic>).map(
                (item) => {
                  'serviceName': item['serviceName'],
                  'subCatTitle': item['subCatTitle'],
                  'price': item['price'],
                  'quantity': item['quantity'],
                  'unit': item['unit'],
                },
              ).toList(),
              'totalAmount': orderData['totalAmount'],
              'totalToPay': orderData['totalToPay'],
              'providerName': orderData['providerName'],
              'providerMobile': orderData['providerMobile'],
              'providerImg': orderData['providerImg'],
              'orderStatus': orderData['orderStatus'],
              'paymentStatus': orderData['paymentStatus'],
              'paymentType': orderData['paymentType'],
              'paymentRef': orderData['paymentRef'],
              'paymentTxid': orderData['paymentTxid'],
            },
          );
        },
      );
      _orders = loadedOrders;
      notifyListeners();
    } catch (e) {
      print(e);
      return;
    }
  }

  Future<void> addOrder({
    required Map<String, dynamic> customerDetails,
    required DateTime dateTime,
    required Map<String, CartItem> items,
    required String authToken,
    required String userId,
    required double totalAmount,
  }) async {
    List<CartItem> extractedItems = [];
    items.forEach((prodId, item) {
      extractedItems.add(item);
    });

    var url = Uri.parse(
        'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    var response = await http.post(
      url,
      body: json.encode(
        {
          'customerName': customerDetails['name'],
          'customerMobile': customerDetails['mobile'],
          'dateTime': dateTime.toIso8601String(),
          'services': extractedItems
              .map((item) => {
                    'serviceName': item.serviceName,
                    'subCatTitle': item.subCatTitle,
                    'price': item.price,
                    'quantity': item.quantity,
                    'unit': item.unit,
                  })
              .toList(),
          'totalAmount': totalAmount,
          'totalToPay': totalAmount,
          'providerName': 'NA',
          'providerMobile': 'NA',
          'providerImg': 'NA',
          'orderStatus': 'Order Placed',
          'paymentStatus': 'due',
          'paymentType': 'pay with cash',
          'paymentRef': 'NA',
          'paymentTxid': 'NA',
        },
      ),
    );
    var orderId = json.decode(response.body)['name'];
    _orderId = orderId.toString();
    url = Uri.parse(
        'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId/$orderId.json?auth=$authToken');
    await http.patch(url, body: json.encode({'paymentRef': orderId.toString()}));

    notifyListeners();
  }

  Future<void> updatePayment({
    required String type,
    required String userId,
    required String authToken,
    required String orderId,
    required String txid,
    required String paymentStatus,
  }) async {
    final url = Uri.parse(
        'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId/$orderId.json?auth=$authToken');
    await http.patch(
      url,
      body: json.encode(
        {
          'paymentType': type,
          'paymentStatus': paymentStatus,
          'paymentTxid': txid,
          'totalToPay': 0,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> updateProvider({
    required Map<String, dynamic> providerDetails,
    required String userId,
    required String authToken,
    required String orderId,
    required String orderStatus,
  }) async {
    final url = Uri.parse(
        'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/orders/$userId/$orderId.json?auth=$authToken');
    await http.patch(
      url,
      body: json.encode(
        {
          'providerName': providerDetails['name'],
          'providerMobile': providerDetails['mobile'],
          'providerImg': providerDetails['profilePic'],
          'orderStatus': orderStatus,
        },
      ),
    );
    notifyListeners();
  }
}
