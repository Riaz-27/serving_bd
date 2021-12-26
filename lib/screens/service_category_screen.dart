import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serving_bd/providers/cart.dart';
import 'package:serving_bd/providers/sub_category.dart';
import 'package:serving_bd/screens/order_details_screen.dart';

import '../providers/service.dart';
import '../providers/services.dart';

class ServiceCategoryScreen extends StatefulWidget {
  final String title;
  final int selectedServiceIndex;
  final int selectedCategoryIndex;
  const ServiceCategoryScreen({
    Key? key,
    required this.title,
    required this.selectedServiceIndex,
    required this.selectedCategoryIndex,
  }) : super(key: key);

  @override
  State<ServiceCategoryScreen> createState() => _ServiceCategoryScreenState();
}

class _ServiceCategoryScreenState extends State<ServiceCategoryScreen> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    //Fetching sub categories
    List<List<Service>> _services = context.read<Services>().services;
    Service _selectedService =
        _services[widget.selectedCategoryIndex][widget.selectedServiceIndex];
    List<SubCategory> _subCategories = _selectedService.subCategory;

    //Fetching cart items
    Map<String, CartItem> items = context.read<Cart>().items;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          constraints: const BoxConstraints(
            maxHeight: 40,
            maxWidth: 40,
          ),
          onPressed: () {
            context.read<Cart>().clear();
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      floatingActionButton: _quantity > 0 ? buildFloatingActionButton() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _selectedService.subCategoryTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _subCategories.length,
                itemBuilder: (_, index) {
                  String productId =
                      '${widget.selectedCategoryIndex} + ${widget.selectedServiceIndex} + $index';
                  int quantity =
                      context.read<Cart>().getItemQuantity(productId);
                  return buildCatList(
                    productId: productId,
                    serviceName: widget.title,
                    subCatTitle: _subCategories[index].title,
                    price: _subCategories[index].price.toDouble(),
                    unit: _subCategories[index].unit,
                    quantity: quantity,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCatList({
    required String productId,
    required String serviceName,
    required String subCatTitle,
    required double price,
    required String unit,
    required int quantity,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    subCatTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("৳ $price / $unit"),
              ],
            ),
            quantity < 1
                ? InkWell(
                    onTap: () {
                      setState(() {
                        context.read<Cart>().addItem(productId, price,
                            serviceName, subCatTitle, unit, quantity);
                        _quantity++;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFC61F62),
                        ),
                        color: const Color(0xFFFFFFFF),
                      ),
                      height: 35,
                      width: 70,
                      child: const Center(
                        child: Text(
                          "Add+",
                          style: TextStyle(
                            color: Color(0xFFC61F62),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                : Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: Color(0xFFC61F62),
                        ),
                        height: 25,
                        width: 30,
                        child: GestureDetector(
                          onTap: () {
                            if (quantity > 0) {
                              setState(() {
                                context.read<Cart>().removeItem(productId);
                                _quantity--;
                              });
                            }
                          },
                          child: const Icon(
                            Icons.remove,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFC61F62),
                          ),
                        ),
                        height: 25,
                        width: 50,
                        child: Center(
                          child: Text(
                            "$quantity $unit",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: Color(0xFFC61F62),
                        ),
                        height: 25,
                        width: 30,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              context.read<Cart>().addItem(productId, price,
                                  serviceName, subCatTitle, unit, quantity);
                              _quantity++;
                            });
                          },
                          child: const Icon(
                            Icons.add,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton() {
    final deviceSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            // elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              height: 40,
              width: (deviceSize.width / 2) - 10,
              child: Center(
                child: Text(
                  "Total ৳ ${context.watch<Cart>().totalAmount}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) {
                  return OrderDetailsScreen();
                }),
              );
            },
            child: Card(
              // elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: const Color(0xFFC61F62),
              child: SizedBox(
                height: 40,
                width: (deviceSize.width / 2) - 50,
                child: const Center(
                  child: Text(
                    "Proceed",
                    style: TextStyle(
                      fontSize: 16,
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
    );
  }
}
