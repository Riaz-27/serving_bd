import 'package:flutter/material.dart';

class CartItem {
  final String serviceName;
  final String subCatTitle;
  final double price;
  final int quantity;
  final String unit;
  final String serviceType;

  CartItem({
    required this.serviceName,
    required this.subCatTitle,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.serviceType,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  int getItemQuantity(String productId){
    if (!_items.containsKey(productId)){
      return 0;
    }
    return _items[productId]!.quantity;
  }

  void addItem({
    required String productId,
    required double price,
    required String serviceName,
    required String serviceType,
    required String subCatTitle,
    required String unit,
    required int quantity,
  }
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (currentItem) => CartItem(
          serviceName: currentItem.serviceName,
          subCatTitle: currentItem.subCatTitle,
          unit: currentItem.unit,
          price: currentItem.price,
          serviceType: currentItem.serviceType,
          quantity: currentItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          serviceType: serviceType,
          serviceName: serviceName,
          subCatTitle: subCatTitle,
          unit: unit,
          price: price,
          quantity: 1,
        ),
      );
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    if(!_items.containsKey(productId)){
      return;
    }
    if(_items[productId]!.quantity>1){
      _items.update(
        productId,
        (currentItem) => CartItem(
          serviceName: currentItem.serviceName,
          serviceType: currentItem.serviceType,
          subCatTitle: currentItem.subCatTitle,
          unit: currentItem.unit,
          price: currentItem.price,
          quantity: currentItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
