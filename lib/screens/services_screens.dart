import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/widgets/services_list_view.dart';

import '../providers/services.dart';
import '../providers/service.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);
  static const routeName = '/service-page';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  int _selectedIndex = 0;
  List<String> _categories = [];
  List<List<Service>> _services = [];
  var _isLoading = true;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    context.read<Services>().fetchAndSetServices().then((_) {
      _categories = context.read<Services>().categories;
      _services = context.read<Services>().services;
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(_isLoading){
      _selectedIndex = ModalRoute.of(context)!.settings.arguments as int;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Services"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                  color: Color.fromRGBO(198, 31, 98, 1)),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 45,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (_, index) {
                        return buildTopNav(index, _categories[index]);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _services[_selectedIndex].length,
                      itemBuilder: (_, index) {
                        return ServiceListView(
                          index: index,
                          categoryIndex: _selectedIndex,
                          title: _services[_selectedIndex][index].name,
                          subtitle: _services[_selectedIndex][index].subtitle,
                          imageUrl: (_services[_selectedIndex][index].imageUrl),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget buildTopNav(int index, String text) {
    const color1 = Color.fromRGBO(198, 31, 98, 1);
    const color2 = Color.fromRGBO(55, 54, 86, 1);
    final isActive = _selectedIndex == index;
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 45,
        child: InkWell(
          child: Card(
            elevation: 4,
            color: isActive ? color1 : Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: isActive ? Colors.white : color2,
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
