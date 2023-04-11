import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auction_app/model/constants.dart';
import 'package:flutter_auction_app/view/screens/add_employee.dart';
import 'package:flutter_auction_app/view/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllUserScreen extends ConsumerStatefulWidget {
  const AllUserScreen({super.key});
  static const id = "/allUser";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends ConsumerState<AllUserScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final userName = ref.watch(userNameState);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, AddEmployeeScreen.id);
        },
        child: const Icon(Icons.add),
      ),
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
              "All users",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            //SizedBox(height: size.height * 0.02),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: size.height * 0.68,
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        if (snapshot.data!.docs[index]["name"] != userName) {
                          return Container(
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
                              trailing: IconButton(
                                onPressed: () {
                                  //get the ref id;
                                  final refId =
                                      snapshot.data!.docs[index].reference.id;
                                  //delete the item.
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(refId)
                                      .delete();
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.redAccent,
                                ),
                              ),
                              subtitle: Text(
                                  snapshot.data!.docs[index]["designation"]),
                            ),
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
          ],
        ),
      ),
    );
  }
}
