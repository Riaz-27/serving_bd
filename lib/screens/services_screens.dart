import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/services.dart';
import '../providers/service.dart';

import 'package:serving_bd/screens/service_category_screen.dart';

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
                        return buildServiceList(
                          index: index,
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
    return InkWell(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 45,
        child: InkWell(
          child: Card(
            elevation: 4,
            color: isActive ? color1 : Colors.white,
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(10),
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

  Widget buildServiceList({
    required int index,
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return ServiceCategoryScreen(title: title, selectedServiceIndex: index, selectedCategoryIndex: _selectedIndex,);
            },
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Icon(
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
