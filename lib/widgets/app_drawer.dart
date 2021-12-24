import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:serving_bd/providers/auth.dart';
import 'package:serving_bd/screens/auth_screen.dart';
import 'package:serving_bd/screens/profile_screen.dart';

class AppDrawer extends StatelessWidget {
  Map<String, dynamic> userData;

  AppDrawer({required this.userData});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(
                      userData['profilePic'],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['name'],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    userData['mobile'],
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color.fromRGBO(198, 31, 98, 1),
                      ),
                      Text(userData['address']),
                    ],
                  )
                ],
              ),
            ),
            drawerList(
              ctx: context,
              icon: Icons.people_alt_outlined,
              text: "Profile",
              index: 0,
            ),
            drawerList(
              ctx: context,
              icon: Icons.settings_outlined,
              text: "Settings",
              index: 1,
            ),
            drawerList(
              ctx: context,
              icon: Icons.shopping_cart_outlined,
              text: "Orders",
              index: 2,
            ),
            Divider(),
            drawerList(
              ctx: context,
              icon: Icons.logout_outlined,
              text: "Logout",
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerList({
    required BuildContext ctx,
    required IconData icon,
    required String text,
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color.fromRGBO(198, 31, 98, 1),
        ),
        title: Text(text),
        onTap: () {
          switch (index) {
            case 0:
              Navigator.of(ctx).push(
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
              break;
            case 3:
              ctx.read<Auth>().logout();
              Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const AuthScreen(),
                ),
              );
          }

          // if (index == 3) {
          //   ctx.read<Auth>().logout();
          //   Navigator.of(ctx).pushReplacement(
          //     MaterialPageRoute(
          //       builder: (_) => const AuthScreen(),
          //     ),
          //   );
          // }
        },
      ),
    );
  }
}
