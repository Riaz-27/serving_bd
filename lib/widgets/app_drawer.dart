import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
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
                      "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Nazrul Islam",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "@nazrul12",
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Color.fromRGBO(198, 31, 98, 1),
                      ),
                      Text("Feni, Chittagong"),
                    ],
                  )
                ],
              ),
            ),
            drawer_list(Icons.people_alt_outlined, "Profile"),
            drawer_list(Icons.settings_outlined, "Settings"),
            drawer_list(Icons.shopping_cart_outlined, "Orders"),
            drawer_list(Icons.logout_outlined, "Logout"),
          ],
        ),
      ),
    );
  }

  Widget drawer_list(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: ListTile(
        leading: Icon(
          icon,
          color: Color.fromRGBO(198, 31, 98, 1),
        ),
        title: Text(text),
        onTap: () {},
      ),
    );
  }
}
