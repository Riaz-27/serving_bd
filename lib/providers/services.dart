import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/service.dart';
import '../providers/sub_category.dart';

class Services with ChangeNotifier {
  List<Service> _services = [];
  List<String> _categories = [];

  //getters
  List<Service> get services => [..._services];
  List<String> get categories => [..._categories];

  Future<void> fetchAndSetServices() async {
    try {
      var url = Uri.parse(
          'https://serving-bd-default-rtdb.asia-southeast1.firebasedatabase.app/services.json');
      final response = await http.get(url);
      print(response.body);
      final List<Service> loadedServices = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<String> loadedCategory = [];
      extractedData.forEach((cat, serviceData) {
        loadedCategory.add(cat);
        (serviceData as Map<String, dynamic>).forEach(
          (serviceName, data) {
            List<SubCategory> extractedSubCat = [];
            for (Map<String, dynamic> subCat in data['subCategory']) {
              extractedSubCat.add(
                SubCategory(
                  title: subCat['title'],
                  price: (subCat['price'] as int).toDouble(),
                  unit: subCat['unit'],
                ));
            }
            loadedServices.add(
              Service(
                name: serviceName,
                imageUrl: data['imageUrl'],
                categoryName: cat,
                subCategory: extractedSubCat,
              ),
            );
          },
        );
      });
      _categories = loadedCategory;
      _services = loadedServices;
      notifyListeners();
    } catch (e) {
      return print(e);
    }
  }
}
