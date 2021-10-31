import 'dart:convert';

import 'package:http/http.dart' as http;

import '../providers/service.dart';

class Services {
  List<Service> _services = [];
  
  List<Service> get services {
    return [..._services];
  }

  
}