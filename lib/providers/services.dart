import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/service.dart';
import '../providers/sub_category.dart';

class Services with ChangeNotifier {
  List<List<Service>> _services = [];
  List<String> _categories = [];

  //getters
  List<List<Service>> get services => [..._services];
  List<String> get categories => [..._categories];

  Future<void> fetchAndSetServices() async {
    try {
      var url = Uri.parse(
          'https://serving-bd-2-default-rtdb.asia-southeast1.firebasedatabase.app/services.json');
      final response = await http.get(url);
      print(response.body);
      final List<List<Service>> loadedServices = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<String> loadedCategory = [];
      extractedData.forEach((cat, serviceData) {
        loadedCategory.add(cat);
        List<Service> loadedService = [];
        (serviceData as Map<String, dynamic>).forEach(
          (serviceName, data) {
            List<SubCategory> extractedSubCat = [];
            num lowestPrice = 100000;
            for (Map<String, dynamic> subCat in data['subCategory']) {
              num _price = (subCat['price'] as num);
              if(_price < lowestPrice) lowestPrice = _price;

              extractedSubCat.add(
                SubCategory(
                  title: subCat['title'],
                  price: _price,
                  unit: subCat['unit'],
                ));
            }
            loadedService.add(
              Service(
                name: serviceName,
                subtitle: 'Starts from ৳ $lowestPrice',
                imageUrl: (data['imageUrl']),
                categoryName: cat,
                subCategory: extractedSubCat,
                subCategoryTitle: data['subCategoryTitle'],
              ),
            );
          },
        );
        loadedServices.add(loadedService);
      });
      _categories = loadedCategory;
      _services = loadedServices;
      notifyListeners();
    } catch (e) {
      return print(e);
    }
  }
}
