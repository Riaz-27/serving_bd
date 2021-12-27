import 'package:flutter/material.dart';
import 'package:serving_bd/screens/auth_screen.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  int _selectedOption = 0;

  final List<String> _options = [
    'Want To Get Service',
    'Want To Provide Service',
  ];

  Widget buildOptions({required int index}) {
    const color1 = Color.fromRGBO(198, 31, 98, 1);
    const color2 = Color.fromRGBO(55, 54, 86, 1);
    const color3 = Color.fromRGBO(253, 244, 249, 1);

    var isActive = _selectedOption == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: isActive ? color1 : Colors.grey),
            borderRadius: BorderRadius.circular(10),
            color: isActive ? color3 : Colors.white,
          ),
          child: Center(
            child: Text(
              _options[index],
              style: TextStyle(
                fontSize: isActive ? 18 : 16,
                color: isActive ? color1 : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            const Text(
              'WELCOME',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Select an option to continue',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            buildOptions(index: 0),
            buildOptions(index: 1),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) {
                        return AuthScreen(userType: _selectedOption);
                      },
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFC61F62),
                  ),
                  height: 40,
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
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
    );
  }
}
