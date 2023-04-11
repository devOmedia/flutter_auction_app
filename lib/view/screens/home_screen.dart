import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auction_app/model/constants.dart';
import 'package:flutter_auction_app/view/screens/all_user_list_screen.dart';
import 'package:flutter_auction_app/view/screens/login_screen.dart';
import 'package:flutter_auction_app/view/screens/my_product_screen.dart';
import 'package:flutter_auction_app/view/screens/splash_screen.dart';
import 'package:flutter_auction_app/view/screens/user_messanger.dart';
import 'package:flutter_auction_app/view/widgets/post_item_bottomsheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  static const id = "/home";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedNavItem = 0;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.height * 0.06),
            if (ref.watch(isManagerProvider))
              Text(
                "Hello Mr. Manager",
                style: Theme.of(context).textTheme.titleLarge,
              )
            else
              Text(
                "Hello Mr. Nirob",
                style: Theme.of(context).textTheme.titleLarge,
              ),
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
                    height: size.height * 0.75,
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "৳ ${snapshot.data!.docs[index]["price"] ?? 0}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (ref.watch(isManagerProvider))
                                    IconButton(
                                      onPressed: () {
                                        //get the ref id;
                                        final refId = snapshot
                                            .data!.docs[index].reference.id;
                                        //delete the item.
                                        FirebaseFirestore.instance
                                            .collection("auction_data")
                                            .doc(refId)
                                            .delete();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                    )
                                ],
                              ),
                              leading: Image.asset(
                                "assets/images/product.jpg",
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
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: KConstColors.iconColor,
        backgroundColor: KConstColors.secondaryColor,
        unselectedItemColor: KConstColors.secondaryColor,
        currentIndex: selectedNavItem,
        onTap: (value) {
          setState(() {
            selectedNavItem = value;
          });

          if (selectedNavItem == 1) {
            Navigator.pushNamed(context, PostItemScreen.id);
          }

          if (selectedNavItem == 2) {
            ref.watch(isManagerProvider) // check if the view is manager view.
                ? Navigator.pushNamed(context, AllUserScreen.id)
                : Navigator.pushNamed(context, MyProductScreen.id);
            selectedNavItem = 0;
          }
          if (selectedNavItem == 3) {
            Navigator.pushNamed(context, MessengerUserScreen.id);
            selectedNavItem = 0;
          }
          if (selectedNavItem == 4) {
            Navigator.pushReplacementNamed(context, SplashScreen.id);
            selectedNavItem = 0;
            ref.read(isManagerProvider.notifier).state = false;
            ref.read(isClientProvider.notifier).state = false;
          }
        },
        items: [
          //=========================>> gallery
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.home,
            ),
            label: selectedNavItem == 0 ? "Home" : "",
          ),
          //============================>> post
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.add,
            ),
            label: selectedNavItem == 1 ? "Post" : "",
          ),
          ref.watch(isManagerProvider) // if the manager then all user list.
              ? BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.face_2,
                  ),
                  label: selectedNavItem == 2 ? "Customers" : "",
                )
              : BottomNavigationBarItem(
                  icon: const Icon(
                    Icons.post_add,
                  ),
                  label: selectedNavItem == 2 ? "Posted Item" : "",
                ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.message,
            ),
            label: selectedNavItem == 3 ? "Message" : "",
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.logout,
            ),
            label: selectedNavItem == 3 ? "Log Out" : "",
          ),
        ],
      ),
    );
  }
}
