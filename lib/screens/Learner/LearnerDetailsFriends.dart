import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/screens/Learner/LeanerChattingPage.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/widgets/showingwidget.dart';

class LeaarnnerDetailsFriend extends StatelessWidget {
  final StudyUser userData;
  final StudyUser currentuser;
  final bool isadd;

  const LeaarnnerDetailsFriend({
    super.key,
    required this.userData,
    required this.currentuser,
    required this.isadd,
  });
  Future<void> _showDialog(
      BuildContext context, String title, String content) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("title"),
        content: Text(
          content,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Ok",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.network(userData.image_url),
                          ),
                        ]),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 30, 30, 0),
                        child: Column(children: [
                          ShowingWidget(
                              name: "Userrole",
                              namevalue: userData.userrole,
                              icon: Icon(CupertinoIcons.person_solid)),
                          ShowingWidget(
                              name: "Username",
                              namevalue: userData.username,
                              icon: Icon(CupertinoIcons.person)),
                          ShowingWidget(
                              name: "Email",
                              namevalue: userData.email,
                              icon: Icon(CupertinoIcons.mail)),
                          ShowingWidget(
                              name: "Phone Number",
                              namevalue: userData.phonenumber,
                              icon: Icon(CupertinoIcons.phone)),
                          ShowingWidget(
                              name: "Status",
                              namevalue: userData.status,
                              icon: Icon(CupertinoIcons.star)),
                        ])),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String userInput = '';
                                    return AlertDialog(
                                      title: Text('Provide Reason for report'),
                                      content: TextField(
                                        maxLines: null,
                                        onChanged: (value) {
                                          userInput = value;
                                        },
                                      ),
                                      actions: [
                                        TextButton(
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Report action cancelled.'),
                                              duration: Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ));
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Submit',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          onPressed: () async {
                                            DocumentReference
                                                documentReference =
                                                await FirebaseFirestore.instance
                                                    .collection('reports')
                                                    .add({
                                              'reason': userInput,
                                              'reporterID': currentuser.uid,
                                              'status': 'OPEN',
                                              'victimID': userData.uid,
                                            });
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'Report Submitted for Review.'),
                                              duration: Duration(seconds: 2),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ));
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red[400]),
                              ),
                              child: const Text("Report",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                          ),
                          //if (!application || !accept)
                          SizedBox(
                            width: 130,
                            child: ElevatedButton(
                              onPressed: isadd
                                  ? () async {
                                      await currentuser
                                          .makeapplication(userData.uid);
                                      // await currentuser
                                      //     .applicationbackup(userData.uid);
                                      await showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("Add Friends"),
                                          content: Text(
                                              "Success to make application to ${userData.username}"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                "Ok",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      Navigator.pop(context, true);
                                    }
                                  : () async {
                                      DocumentSnapshot user1Rooms =
                                          await FirebaseFirestore.instance
                                              .collection('chatRooms')
                                              .doc(userData.uid)
                                              .get();
                                      DocumentSnapshot user2Rooms =
                                          await FirebaseFirestore.instance
                                              .collection('chatRooms')
                                              .doc(currentuser.uid)
                                              .get();

                                      if (user1Rooms.exists &&
                                          user2Rooms.exists) {
                                        bool continueTask = true;
                                        List<dynamic> user1RoomsID =
                                            user1Rooms['chatRoomsID'];
                                        List<dynamic> user2RoomsID =
                                            user2Rooms['chatRoomsID'];
                                        List<dynamic> commonRoomsID =
                                            user1RoomsID
                                                .where((element) => user2RoomsID
                                                    .contains(element))
                                                .toList();
                                        for (int i = 0;
                                            i < commonRoomsID.length;
                                            i++) {
                                          DocumentSnapshot commonRoomData =
                                              await FirebaseFirestore.instance
                                                  .collection('chatContent')
                                                  .doc(commonRoomsID[i])
                                                  .get();
                                          String commonRoomName =
                                              commonRoomData['chatRoomName'];
                                          List<String> splitRoomName =
                                              commonRoomName.split(':');
                                          if (splitRoomName[0] == 'DM') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatScreen(
                                                        chatRoomID:
                                                            commonRoomsID[i],
                                                      )),
                                            );
                                            continueTask = false;
                                            break;
                                          }
                                        }
                                        if (continueTask) {
                                          DocumentReference newDocRef =
                                              await FirebaseFirestore.instance
                                                  .collection('chatContent')
                                                  .add({
                                            'chatRoomName':
                                                "DM:${currentuser.uid}:${userData.uid}",
                                            'latest_text': 'New Chat'
                                          });

                                          if (user1Rooms.exists == false) {
                                            await FirebaseFirestore.instance
                                                .collection('chatRooms')
                                                .doc(userData.uid)
                                                .set({
                                              'chatRoomsID': [],
                                            });
                                          }
                                          if (user2Rooms.exists == false) {
                                            await FirebaseFirestore.instance
                                                .collection('chatRooms')
                                                .doc(currentuser.uid)
                                                .set({
                                              'chatRoomsID': [],
                                            });
                                          }

                                          String newChatRoomID = newDocRef.id;

                                          DocumentSnapshot u1Room =
                                              await FirebaseFirestore.instance
                                                  .collection('chatRooms')
                                                  .doc(userData.uid)
                                                  .get();
                                          DocumentSnapshot u2Room =
                                              await FirebaseFirestore.instance
                                                  .collection('chatRooms')
                                                  .doc(currentuser.uid)
                                                  .get();

                                          List<dynamic> u1ChatRoomsID;
                                          List<dynamic> u2ChatRoomsID;

                                          if (u1Room.exists) {
                                            u1ChatRoomsID =
                                                u1Room['chatRoomsID'];
                                          } else {
                                            u1ChatRoomsID = [];
                                          }

                                          if (u2Room.exists) {
                                            u2ChatRoomsID =
                                                u2Room['chatRoomsID'];
                                          } else {
                                            u2ChatRoomsID = [];
                                          }

                                          u1ChatRoomsID.add(newChatRoomID);
                                          u2ChatRoomsID.add(newChatRoomID);
                                          print("user1 rooms: $u1ChatRoomsID");
                                          print("user2 rooms: $u2ChatRoomsID");

                                          await FirebaseFirestore.instance
                                              .collection('chatRooms')
                                              .doc(userData.uid)
                                              .update({
                                            'chatRoomsID': u1ChatRoomsID,
                                          });

                                          await FirebaseFirestore.instance
                                              .collection('chatRooms')
                                              .doc(currentuser.uid)
                                              .update({
                                            'chatRoomsID': u2ChatRoomsID,
                                          });
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChatScreen(
                                                  chatRoomID: newChatRoomID,
                                                ),
                                              ));
                                        }
                                      } else {
                                        // MUST CREATE A NEW CHATROOM FOR BOTH USER
                                        DocumentReference newDocRef =
                                            await FirebaseFirestore.instance
                                                .collection('chatContent')
                                                .add({
                                          'chatRoomName':
                                              "DM:${currentuser.uid}:${userData.uid}",
                                          'latest_text': 'New Chat'
                                        });

                                        if (user1Rooms.exists == false) {
                                          await FirebaseFirestore.instance
                                              .collection('chatRooms')
                                              .doc(userData.uid)
                                              .set({
                                            'chatRoomsID': [],
                                          });
                                        }
                                        if (user2Rooms.exists == false) {
                                          await FirebaseFirestore.instance
                                              .collection('chatRooms')
                                              .doc(currentuser.uid)
                                              .set({
                                            'chatRoomsID': [],
                                          });
                                        }

                                        String newChatRoomID = newDocRef.id;

                                        DocumentSnapshot u1Room =
                                            await FirebaseFirestore.instance
                                                .collection('chatRooms')
                                                .doc(userData.uid)
                                                .get();
                                        DocumentSnapshot u2Room =
                                            await FirebaseFirestore.instance
                                                .collection('chatRooms')
                                                .doc(currentuser.uid)
                                                .get();

                                        List<dynamic> u1ChatRoomsID;
                                        List<dynamic> u2ChatRoomsID;

                                        if (u1Room.exists) {
                                          u1ChatRoomsID = u1Room['chatRoomsID'];
                                        } else {
                                          u1ChatRoomsID = [];
                                        }

                                        if (u2Room.exists) {
                                          u2ChatRoomsID = u2Room['chatRoomsID'];
                                        } else {
                                          u2ChatRoomsID = [];
                                        }

                                        u1ChatRoomsID.add(newChatRoomID);
                                        u2ChatRoomsID.add(newChatRoomID);
                                        print("user1 rooms: $u1ChatRoomsID");
                                        print("user2 rooms: $u2ChatRoomsID");

                                        await FirebaseFirestore.instance
                                            .collection('chatRooms')
                                            .doc(userData.uid)
                                            .update({
                                          'chatRoomsID': u1ChatRoomsID,
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('chatRooms')
                                            .doc(currentuser.uid)
                                            .update({
                                          'chatRoomsID': u2ChatRoomsID,
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatScreen(
                                                chatRoomID: newChatRoomID,
                                              ),
                                            ));
                                      }
                                    },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.green[400]),
                              ),
                              child: isadd
                                  ? const Text("Add Friends")
                                  : const Text("Chat",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ))));
  }
}
