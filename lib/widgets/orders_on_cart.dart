import 'package:flutter/material.dart';

class OrdersOnCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (_, index) {
          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Home Deep Clean",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "800 - 1000 sft",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.remove, size: 20,),
                            ),
                            SizedBox(
                              width: 40,
                              child: Text("1 Unit"),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.add, size: 20,),
                            )
                          ],
                        ),
                        Text("data")
                      ],
                    )
                  ],
                ),
              ),
              // child: Padding(
              //   padding:
              //       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              //   child: ListTile(
              //     title: Text(
              //       "Home Deep Clean",
              //       style: TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     subtitle: Text(
              //       "800 - 1000 sft",
              //       style: TextStyle(
              //         fontSize: 14,
              //       ),
              //     ),
              //     trailing: Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 10),
              //       child: Column(
              //         children: [
              //           SizedBox(
              //             width: 80,
              //             height: 30,
              //             child: Row(
              //               children: [
              //                 IconButton(
              //                   icon: Icon(Icons.remove,size: 30,),
              //                   onPressed: () {},
              //                 ),
              //                 SizedBox(
              //                   width: 40,
              //                   child: Text("1 Unit"),
              //                 ),
              //                 IconButton(
              //                   icon: Icon(Icons.add,size: 30,),
              //                   onPressed: () {},
              //                 )
              //               ],
              //             ),
              //           ),
              //           SizedBox(
              //             height: 5,
              //           ),
              //           Text("1"),
              //           Text("1"),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ),
          );
        },
      ),
    );
  }
}
