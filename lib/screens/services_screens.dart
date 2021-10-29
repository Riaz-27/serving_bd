import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);
  static const routeName = '/service-page';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Services"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (_, index) {
                  return buildTopNav(index, "Test");
                },
              ),
            ),
          ),
          Center(child: Text("data"),)
        ],
      ),
    );
  }

  Widget buildTopNav(int index, String text) {
    final color1 = const Color.fromRGBO(198, 31, 98, 1);
    final color2 = const Color.fromRGBO(55, 54, 86, 1);
    final isActive = _selectedIndex == index;
    return InkWell(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 45,
        width: 110,
        child: InkWell(
          child: Card(
            elevation: 4,
            color: isActive ? color1 : Colors.white,
            child: Center(
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
