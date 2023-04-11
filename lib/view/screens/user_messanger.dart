import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auction_app/model/constants.dart';
import 'package:flutter_auction_app/view/screens/login_screen.dart';
import 'package:flutter_auction_app/view/screens/messege_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessengerUserScreen extends ConsumerStatefulWidget {
  const MessengerUserScreen({super.key});
  static const id = "/messengerUser";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MessengerUserScreenState();
}

class _MessengerUserScreenState extends ConsumerState<MessengerUserScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
        title: const Text(
          "Messenger",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: size.height * 0.65,
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    if (ref.watch(isManagerProvider)) {
                      if (snapshot.data!.docs[index]["name"] != "Mr. Manager") {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewMessageScreen(
                                  name: snapshot.data!.docs[index]["name"],
                                  image: snapshot.data!.docs[index]["image"],
                                  docID: snapshot.data!.docs[index]["name"]
                                      .toString()
                                      .toLowerCase(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                              margin: const EdgeInsets.all(8),
                              //height: size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: KConstColors.hintColor,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                title: Text(snapshot.data!.docs[index]["name"]),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: SizedBox(
                                    height: size.height * 0.1,
                                    width: size.width * 0.15,
                                    child: Image.network(
                                      snapshot.data!.docs[index]["image"],
                                    ),
                                  ),
                                ),
                              )),
                        );
                      }
                    } else {
                      if (snapshot.data!.docs[index]["name"] != "Nirob Khan") {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewMessageScreen(
                                  name: snapshot.data!.docs[index]["name"],
                                  image: snapshot.data!.docs[index]["image"],
                                  docID: snapshot.data!.docs[index]["name"]
                                      .toString()
                                      .toLowerCase()
                                      .trim(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                              margin: const EdgeInsets.all(8),
                              //height: size.height * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: KConstColors.hintColor,
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                title: Text(snapshot.data!.docs[index]["name"]),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: SizedBox(
                                    height: size.height * 0.1,
                                    width: size.width * 0.15,
                                    child: Image.network(
                                      snapshot.data!.docs[index]["image"],
                                    ),
                                  ),
                                ),
                              )),
                        );
                      }
                    }

                    return const Text("");
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
      ),
    );
  }
}
