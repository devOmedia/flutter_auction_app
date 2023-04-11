import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
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
  String getConversationId(String user1Id, String user2Id) {
    // Sort the user IDs alphabetically to ensure consistency
    List<String> sortedIds = [user1Id, user2Id]..sort();

    // Concatenate the sorted IDs with a separator
    String concatenatedIds = sortedIds.join(':');

    // Hash the concatenated IDs to produce a unique ID
    var bytes = utf8.encode(concatenatedIds);
    var digest = sha1.convert(bytes);
    String conversationId = digest.toString();

    print("conv id:=====>>> $conversationId");

    return conversationId;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final user = ref.watch(userNameState);
    log("user====>> $user");
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
                    if (snapshot.data!.docs[index]["name"] != user) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewMessageScreen(
                                name: snapshot.data!.docs[index]["name"],
                                image: snapshot.data!.docs[index]["image"],
                                docID: getConversationId(
                                  user!,
                                  snapshot.data!.docs[index]["name"],
                                ),
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

                    return const SizedBox();
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
