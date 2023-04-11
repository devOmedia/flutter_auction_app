import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auction_app/model/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProductScreen extends ConsumerStatefulWidget {
  const MyProductScreen({super.key});
  static const id = "/myProductScreen";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyProductScreenState();
}

class _MyProductScreenState extends ConsumerState<MyProductScreen> {
  int selectedNavItem = 0;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Icon(Icons.arrow_back_ios_new),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              "My Products List",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: size.height * 0.04),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("auction_data")
                  .orderBy(
                    "time",
                    descending: false,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: size.height * 0.68,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        return Container(
                            margin: const EdgeInsets.all(8),
                            //height: size.height * 0.15,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: KConstColors.hintColor,
                            ),
                            child: ListTile(
                              title: Text(
                                  snapshot.data!.docs[index]["product_name"]),
                              subtitle: Text(snapshot.data!.docs[index]
                                  ["product_details"]),
                              trailing: Text(
                                "৳ ${snapshot.data!.docs[index]["price"] ?? 0}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              leading: Image.network(
                                "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZHVjdHxlbnwwfHwwfHw%3D&w=1000&q=80",
                                fit: BoxFit.fill,
                              ),
                            ));
                      }),
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: KConstColors.secondaryColor,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: KConstColors.iconColor,
      //   backgroundColor: KConstColors.secondaryColor,
      //   unselectedItemColor: KConstColors.secondaryColor,
      //   currentIndex: selectedNavItem,
      //   onTap: (value) {
      //     setState(() {
      //       selectedNavItem = value;
      //     });

      //     if (selectedNavItem == 1) {
      //       Navigator.pushNamed(context, PostItemScreen.id);
      //     }

      //     if (selectedNavItem == 2) {
      //       Navigator.pushNamed(context, MyProductScreen.id);
      //     }
      //   },
      //   items: [
      //     //=========================>> gallery
      //     BottomNavigationBarItem(
      //       icon: const Icon(
      //         Icons.home,
      //       ),
      //       label: selectedNavItem == 0 ? "Home" : "",
      //     ),
      //     //============================>> post
      //     BottomNavigationBarItem(
      //       icon: const Icon(
      //         Icons.add,
      //       ),
      //       label: selectedNavItem == 1 ? "Post" : "",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: const Icon(
      //         Icons.post_add,
      //       ),
      //       label: selectedNavItem == 2 ? "Posted Item" : "",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: const Icon(
      //         Icons.message,
      //       ),
      //       label: selectedNavItem == 3 ? "Posted Item" : "",
      //     ),
      //   ],
      // ),
    );
  }
}
