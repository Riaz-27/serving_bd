import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:serving_bd/main.dart';

import '../screens/services_screens.dart';

class HomeScreen extends StatelessWidget {
  Map<String,dynamic> userData;

  HomeScreen({required this.userData});

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MainPage(
                          userData: userData,
                          selectedItemIndex: 1,
                          autoFocus: true,
                        ),
                      ),
                    );
                  },
                  readOnly: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: "Search by service or categories",
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                height: 125,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://s3.ap-south-1.amazonaws.com/cdn-marketplacexyz/sheba_xyz/images/webp/why-choose-us.webp"),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GridView(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    children: [
                      buildCategoryCard(
                        context: context,
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/categories_images/icons_png/1601959826_ac_52x52.webp",
                        title: "AC Service",
                        index: 0,
                      ),
                      buildCategoryCard(
                        context: context,
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/categories_images/icons_png/1583681524_tiwnn_52x52.webp",
                        title: "Appliance Repair",
                        index: 1,
                      ),
                      buildCategoryCard(
                        context: context,
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/v4_uploads/category_icons/226/default_52x52.webp",
                        title: "Painting",
                        index: 2,
                      ),
                      buildCategoryCard(
                        context: context,
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/categories_images/icons_png/1583681093_tiwnn_52x52.webp",
                        title: "Shifting",
                        index: 2,
                      ),
                      buildCategoryCard(
                        context: context,
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/category_images/icons_png_hover/1592147258_tiwnn.png",
                        title: "Cleaning",
                        index: 2,
                      ),
                      buildCategoryCard(
                        context: context,
                        imageurl:
                            "https://cdn-marketplacexyz.s3.ap-south-1.amazonaws.com/sheba_xyz/images/svg/all-services.svg",
                        title: "All Services",
                        isSvg: true,
                        index: 0,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCategoryCard({
    required BuildContext context,
    required String imageurl,
    required String title,
    required int index,
    bool isSvg = false,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ServicesScreen.routeName, arguments: index);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              isSvg
                  ? SvgPicture.network(
                      imageurl,
                      height: 35,
                      width: 35,
                    )
                  : Image(
                      image: NetworkImage(imageurl),
                      height: 35,
                      width: 35,
                    ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
