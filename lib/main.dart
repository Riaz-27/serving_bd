import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/screens/auth_screen.dart';

import './screens/home_screen.dart';
import './screens/search_screen.dart';
import './screens/orders_screen.dart';
import './widgets/app_drawer.dart';
import './screens/services_screens.dart';
import './providers/services.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Services(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Serving.bd',
        theme: ThemeData(
            primaryColor: const Color(0xFFC61F62),
            scaffoldBackgroundColor: const Color(0xFFF5F6FB),
            appBarTheme: const AppBarTheme(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              toolbarHeight: 80,
              centerTitle: true,
            )),
        home: auth.isAuth ? MainPage() : AuthScreen(),
        routes: {
          ServicesScreen.routeName: (ctx) => ServicesScreen(),
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedItemIndex = 0;
  final appBarTitles = [
    "Home",
    "Search",
    "Chats",
    "Orders",
  ];
  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(),
      SearchScreen(),
      SearchScreen(),
      OrderScreen(),
    ];

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(appBarTitles[_selectedItemIndex]),
        leading: GestureDetector(
          onTap: () => _scaffoldKey.currentState!.openDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 80,
              width: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: screens[_selectedItemIndex],
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(flex:1 , child: buildBottomNavBar(Icons.home_outlined, 0),),
          Flexible(flex:1 , child: buildBottomNavBar(Icons.search, 1),),
          Flexible(flex:1 , child: buildBottomNavBar(Icons.chat_outlined, 2),),
          Flexible(flex:1 , child: buildBottomNavBar(Icons.shopping_cart_outlined, 3),),
        ],
      ),
    );
  }

  // final iconList = [
  //   Icons.home,
  //   Icons.favorite,
  //   Icons.chat,
  //   Icons.shopping_cart
  // ];
  Widget buildBottomNavBar(IconData icon, int index) {
    final double _iconSize = index == _selectedItemIndex ? 35 : 28;
    // if(index == _selectedItemIndex) icon = iconList[index];
    final _iconColor = index == _selectedItemIndex
        ? const Color.fromRGBO(198, 31, 98, 1)
        : const Color.fromRGBO(55, 54, 86, 1);

    return Container(
      color: Colors.white,
      height: 60,
      child: Row(
        children: [
          SizedBox(
            width: 95,
            height: 60,
            child: InkWell(
              child: Icon(
                icon,
                size: _iconSize,
                color: _iconColor,
              ),
              onTap: () {
                setState(() {
                  _selectedItemIndex = index;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
