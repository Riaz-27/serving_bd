import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/widgets/search_widget.dart';

import '../providers/service.dart';
import '../providers/services.dart';
import '../widgets/services_list_view.dart';

class SearchScreen extends StatefulWidget {
  final bool autoFocus;
  const SearchScreen({Key? key, this.autoFocus = false}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final List<Service> _allServices = [];

  List<Service> filteredServices = [];
  String query = '';

  var _isLoading = false;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    context.read<Services>().fetchAndSetServices(context.read<Auth>().token!).then((_) {
      List<List<Service>> services = context.read<Services>().services;
      for (var catService in services) {
        for (var service in catService) {
          _allServices.add(service);
        }
      }
      filteredServices = _allServices;
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SearchWidget(
                      text: query,
                      hintText: "Service or Category name",
                      onChanged: searchService,
                      autoFocus: widget.autoFocus,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredServices.length,
                        itemBuilder: (_, index) {
                          return ServiceListView(
                            imageUrl: filteredServices[index].imageUrl,
                            title: filteredServices[index].name,
                            index: filteredServices[index].serviceIndex,
                            subtitle: filteredServices[index].subtitle,
                            categoryIndex: filteredServices[index].categoryIndex,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void searchService(String query) {
    final services = _allServices.where((service) {
      final nameLower = service.name.toLowerCase();
      final catLower = service.categoryName.toLowerCase();
      final searchLower = query.toLowerCase();

      return (nameLower.contains(searchLower) || catLower.contains(searchLower));
    }).toList();

    setState(() {
      filteredServices = services;
      this.query = query;
    });
  }
}
