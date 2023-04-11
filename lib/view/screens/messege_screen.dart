import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auction_app/model/constants.dart';
import 'package:flutter_auction_app/view/screens/login_screen.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewMessageScreen extends ConsumerStatefulWidget {
  const NewMessageScreen(
      {super.key,
      required this.name,
      required this.docID,
      required this.image});

  final String name;
  static const id = "/newMsg";
  final String docID;
  final String image;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewMessageScreenState();
}

class _NewMessageScreenState extends ConsumerState<NewMessageScreen> {
  late TextEditingController _msgCtr;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  _sentMessage() async {
    if (_msgCtr.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "message": _msgCtr.text,
        "time": FieldValue.serverTimestamp(),
        if (ref.watch(isManagerProvider)) "sendby": "mr. manager",
        if (ref.watch(isClientProvider)) "sendby": "nirob khan",
        if (ref.watch(isCleanerProvider)) "sendby": "mr. cleaner",
        if (ref.watch(isGuardProvider)) "sendby": "mr.  guard",
      };
//clean text editing ctr.
      _msgCtr.clear();
//send msg to firebase
      firestore
          .collection("chats")
          .doc(widget.docID)
          .collection("chat")
          .add(messages);
    }
  }

  _isSender(String senderName) {
    print("sender $senderName");
// if the msg is received by other then it returns false otherwise false.
    if (senderName.toLowerCase() != widget.name.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }

  _getMessageSendTime(Timestamp? timestamp) {
    if (timestamp != null) {
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      final day = date.day;
      final time = "${date.hour}:${date.minute}";

//if the msg is not sent by the day then day and month will be shown otherwise only time.
      if (DateTime.now().day != day) {
        switch (date.month) {
          case 1:
            return "Jan $day, $time";
          case 2:
            return "Feb $day, $time";
          case 3:
            return "Mar $day, $time";
          case 4:
            return "Api $day, $time";
          case 5:
            return "May $day, $time";
          case 6:
            return "Jun $day, $time";
          case 7:
            return "Jul $day, $time";
          case 8:
            return "Aug $day, $time";
          case 9:
            return "Sep $day, $time";
          case 10:
            return "Oct $day, $time";
          case 11:
            return "Nov $day, $time";
          case 12:
            return "Dec $day, $time";
        }
      } else {
        return time;
      }
    }
  }

  @override
  void initState() {
    _msgCtr = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _msgCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print(widget.docID);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(25),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              widget.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            )
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: KConstColors.primaryColor,
              border: Border.all(color: KConstColors.greyColor),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.phone_enabled,
                color: KConstColors.secondaryColor,
              ),
              onPressed: () async {
                //await launchPhoneDialer("01727493053");
              },
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection("chats")
                    .doc(widget.docID)
                    .collection("chat")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> data = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return Column(
                            children: [
                              Align(
                                alignment: _isSender(data["sendby"])
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  _getMessageSendTime(data["time"]) ?? "",
                                  textAlign: _isSender(data["sendby"])
                                      ? TextAlign.right
                                      : TextAlign.left,
                                ),
                              ),
                              BubbleSpecialThree(
                                text: data["message"],
                                color: _isSender(data["sendby"])
                                    ? const Color(0xFF1B97F3)
                                    : const Color(0xFFE8E8EE),
                                tail: true,
                                textStyle: TextStyle(
                                  color: _isSender(data["sendby"])
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                ),
                                isSender: _isSender(data["sendby"]),
                              ),
                            ],
                          );
                        });
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: KConstColors.secondaryColor,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              )),
              msgSendWidget(size),
            ],
          ),
        ),
      ),
    );
  }

  Row msgSendWidget(Size size) {
    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            margin: const EdgeInsets.only(top: 8, left: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: size.height * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 213, 213, 233),
              border: Border.all(
                color: KConstColors.secondaryColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _msgCtr,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onFieldSubmitted: (value) {
                      _sentMessage();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        //=======================>>>>send button
        SizedBox(
          width: size.width * 0.15,
          child: GestureDetector(
            onTap: () {
              //FocusScope.of(context).unfocus();
              _sentMessage();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: KConstColors.secondaryColor,
                ),
              ),
              child: const Icon(
                FeatherIcons.send,
                color: KConstColors.secondaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
