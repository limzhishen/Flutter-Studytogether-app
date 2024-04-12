import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/screens/Learner/LeanerChattingPage.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';

class InstructorChat extends StatefulWidget {
  User user;
  InstructorChat({Key? key, required this.user}) : super(key: key);

  @override
  State<InstructorChat> createState() => _InstructorChatState();
}

class chatContentDataField {
  final String latestText;
  final String chatRoomName;
  final String imageLink;

  chatContentDataField(
      {required this.latestText,
      required this.chatRoomName,
      required this.imageLink});
}

class _InstructorChatState extends State<InstructorChat> {
  Future<List<String>> getChatListData(User user) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(user.uid)
        .get();
    List<String> chatRoomsID = [];
    if (documentSnapshot.exists) {
      List<dynamic> chatRooms = documentSnapshot['chatRoomsID'];
      for (var chatRoom in chatRooms) {
        chatRoomsID.add(chatRoom);
      }
    }
    return chatRoomsID;
  }

  Future<List<chatContentDataField>> getChatDataField(chatRoomID) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('chatContent')
            .doc(chatRoomID)
            .get();
    List<chatContentDataField> chatData = [];
    Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
    String chatRoomName = data['chatRoomName'];
    String image_Link = '';
    List<String> parts = chatRoomName.split(':');
    if (parts[0] == 'DM') {
      // This is a DM chat room
      String currentUserID;
      String otherUserID;
      if (parts[1] == widget.user.uid) {
        // The current user is UserIDB
        currentUserID = parts[1];
        otherUserID = parts[2];
      } else {
        // The current user is UserIDA
        currentUserID = parts[2];
        otherUserID = parts[1];
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserID)
          .get();
      String otherUserName = userDoc['username'];
      String imageLink = userDoc['image_url'];
      chatRoomName = '$otherUserName';
      image_Link = imageLink;
    }
    if (parts[0] == 'DM') {
      // This is a DM chat room
      String currentUserID;
      String otherUserID;
      if (parts[1] == widget.user.uid) {
        // The current user is UserIDB
        currentUserID = parts[1];
        otherUserID = parts[2];
      } else {
        // The current user is UserIDA
        currentUserID = parts[2];
        otherUserID = parts[1];
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserID)
          .get();
      String otherUserName = userDoc['username'];
      String imageLink = userDoc['image_url'];
      chatRoomName = '$otherUserName';
      image_Link = imageLink;
    } else if (parts[0] == 'GC') {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('course')
          .doc(parts[1])
          .get();
      String courseName = userDoc['name'];
      String imageLink = userDoc['imageUrl'];
      chatRoomName = '$courseName [COURSE]';
      image_Link = imageLink;
    }
    chatContentDataField chattingData = chatContentDataField(
      latestText: data['latest_text'],
      chatRoomName: chatRoomName,
      imageLink: image_Link,
    );
    chatData.add(chattingData);
    return chatData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                child: Text("Chats",
                    style: Theme.of(context).textTheme.headlineLarge),
              ),
            ],
          ),
          FutureBuilder(
              future: getChatListData(widget.user),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot1.hasError) {
                  return Center(child: Text('Error1: ${snapshot1.error}'));
                } else {
                  List<String> userlist = snapshot1.data as List<String>;
                  return Container(
                      height: MediaQuery.of(context).size.height - 170,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: userlist.length,
                        itemBuilder: (context, index) {
                          String roomID = userlist[index];
                          return FutureBuilder(
                            future: getChatDataField(roomID),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot2.hasError) {
                                return Center(
                                    child: Text('Error2: ${snapshot2.error}'));
                              } else {
                                var chatData = snapshot2.data;
                                if (chatData is List<chatContentDataField>) {
                                  chatContentDataField latestChatData =
                                      chatData[0];
                                  String chatLatestMessage =
                                      latestChatData.latestText;
                                  String chatRoomName =
                                      latestChatData.chatRoomName;
                                  String imageLink = latestChatData.imageLink;
                                  return Row(
                                    children: [
                                      Row(children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                    chatRoomID: roomID,
                                                  ),
                                                )).then((_) => setState(() {}));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 85,
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 3, 0, 3),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 70,
                                                    height: 70,
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                5, 0, 5, 0),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                    child: Image.network(
                                                      imageLink,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(chatRoomName,
                                                          style: TextStyle(
                                                              fontSize: 25,
                                                              fontFamily:
                                                                  'Inter',
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline)),
                                                      Text(chatLatestMessage,
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontFamily:
                                                                  'Inter',
                                                              color:
                                                                  Colors.grey)),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ])
                                    ],
                                  );
                                } else {
                                  return Text('Unexpected data format');
                                }
                              }
                            },
                          );
                        },
                      ));
                }
              }),
        ]),
      ),
    );
  }
}
