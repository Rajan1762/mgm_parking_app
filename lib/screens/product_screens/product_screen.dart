import 'package:flutter/material.dart';

import '../../sevices/network_services/dumy_service.dart';
import '../../utils/constants.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool addValueVisibility = false;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() async {
    await getAllDealsCardData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'TABLE - A10  -  2(persons)',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                    border: InputBorder.none
                ),
              ),
            ),
            Expanded(
              child: dealsCardList != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 10),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1.18,
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 5.0, // Spacing between columns
                          mainAxisSpacing: 5.0, // Spacing between rows
                        ),
                        itemCount:
                            dealsCardList?.length, // Total number of items
                        itemBuilder: (BuildContext context, int index) {
                          // itemBuilder will be called itemCount times, with index ranging from 0 to itemCount - 1
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 1.0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${dealsCardList?[index].productName}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.lightBlue.shade700,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Visibility(
                                        visible: addValueVisibility,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                  color: Colors.green)),
                                          child: const Text(
                                            'Add Notes',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.green),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    child: Text(
                                      '${rupeeSymbol}180.00',
                                      style: TextStyle(
                                          color: Colors.pink.shade300,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('object');
                                      setState(() {
                                        addValueVisibility =
                                            !addValueVisibility;
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4)),
                                          border:
                                              Border.all(color: Colors.green)),
                                      child: addValueVisibility
                                          ? Row(
                                            children: [
                                              const ProductAddRemoveWidget(
                                                  color: Colors.green),
                                              Expanded(
                                                  child: Center(
                                                      child: Text(
                                                '1',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.lightBlue
                                                        .shade700),
                                              ))),
                                              const ProductAddRemoveWidget(
                                                  color: Colors.red),
                                            ],
                                          )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 15,
                                                    width: 15,
                                                    decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    8)),
                                                        border: Border.all(
                                                            color:
                                                                Colors.green)),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.add,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  const Text(
                                                    'Add',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )

                  // ListView.builder(
                  // itemCount: dealsCardList?.length,
                  //     itemBuilder: (context,index)
                  // {
                  //   return Text('${dealsCardList?[index].productName}');
                  // })
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          ],
        ),
      ),
    ));
  }
}

class ProductAddRemoveWidget extends StatelessWidget {
  final Color color;

  const ProductAddRemoveWidget({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipPath(
        clipper: color == Colors.green ? RightArcClipper() : LeftArcClipper(),
        child: Container(height: 30, color: color),
      ),
    );
  }
}

// class RightArcClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(size.width, 0.0);
//     final double controlPointY = size.height / 2;
//     final double endPointY = size.height;
//     path.quadraticBezierTo(size.width, controlPointY, size.width, endPointY);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0.0, size.height);
//     path.close();
//
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

class RightArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.75,size.height * 0.5, size.width, size.height * 0.8);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LeftArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.2);
    path.quadraticBezierTo(size.width * 0.25,size.height * 0.5, 0, size.height * 0.8);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}