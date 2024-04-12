import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/widgets/Friendbox.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';

class AddFriendPage extends StatefulWidget {
  final StudyUser currentuser;
  final VoidCallback? onAddFriend;

  AddFriendPage(
      {super.key, required this.currentuser, required this.onAddFriend});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  void _refreshPage() {
    setState(() {});

    widget.onAddFriend!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: CustomAppBar(),
        body: FutureBuilder(
            future: getallUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<StudyUser> userlist = snapshot.data as List<StudyUser>;
                return FutureBuilder(
                    future: getFriendsData(widget.currentuser.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<StudyUser> friendslist =
                            snapshot.data as List<StudyUser>;

                        userlist.removeWhere((tempuser) {
                          return friendslist.any((friends) {
                            return friends.uid == tempuser.uid;
                          });
                        });
                        userlist.removeWhere((tempuser) {
                          return tempuser.userrole == 'Admin';
                        });
                        userlist.removeWhere((tempuser) {
                          return tempuser.uid == widget.currentuser.uid;
                        });
                        return FutureBuilder(
                            future: widget.currentuser.getapplicationcompare(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                DocumentSnapshot userapplication =
                                    snapshot.data as DocumentSnapshot;
                                return SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    if (userlist.isEmpty)
                                      Container(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 150, 0, 150),
                                        child: const Center(
                                          child: Text('No more Friend for add',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 24)),
                                        ),
                                      ),
                                    if (!userlist.isEmpty)
                                      FriendBox(
                                          userlist: userlist,
                                          currentuser: widget.currentuser,
                                          isadd: true,
                                          onAddFriend: _refreshPage)
                                  ],
                                ));
                              }
                            });
                      }
                    });
              }
            }));
  }
}
