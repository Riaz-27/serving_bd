import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-page';

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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(Icons.search),
                  ),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for any services",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              elevation: 3,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Categories",
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      buildCategoryCard(
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/categories_images/icons_png/1601959826_ac_52x52.webp",
                        title: "AC Service",
                      ),
                      buildCategoryCard(
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/categories_images/icons_png/1583681524_tiwnn_52x52.webp",
                        title: "Repair",
                      ),
                      buildCategoryCard(
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/v4_uploads/category_icons/226/default_52x52.webp",
                        title: "Painting",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      buildCategoryCard(
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/categories_images/icons_png/1583681093_tiwnn_52x52.webp",
                        title: "Shifting",
                      ),
                      buildCategoryCard(
                        imageurl:
                            "https://s3.ap-south-1.amazonaws.com/cdn-shebaxyz/images/category_images/icons_png_hover/1592147258_tiwnn.png",
                        title: "Cleaning",
                      ),
                      buildCategoryCard(
                        imageurl:
                            "https://cdn-marketplacexyz.s3.ap-south-1.amazonaws.com/sheba_xyz/images/svg/all-services.svg",
                        title: "All Services",
                        isSvg: true,
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
}

    Widget buildCategoryCard(
        {required String imageurl, required String title, bool isSvg = false}) {
      return Container(
        width: 106,
        height: 106,
        margin: EdgeInsets.only(right: 17),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              isSvg?
              SvgPicture.network(
                imageurl,
                height: 35,
                width: 35,
              ):
              Image(
                image: NetworkImage(imageurl),
                height: 35,
                width: 45,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(title),
            ],
          ),
        ),
      );
    }
