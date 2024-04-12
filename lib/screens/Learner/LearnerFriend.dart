import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/screens/Learner/AddFriendPage.dart';
import 'package:mae_part2_studytogether/screens/Learner/Learnerapplication.dart';
import 'package:mae_part2_studytogether/widgets/Friendbox.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';

class LearnerFriend extends StatefulWidget {
  User user;
  LearnerFriend({super.key, required this.user});

  @override
  State<LearnerFriend> createState() => _LeannerFriend();
}

class _LeannerFriend extends State<LearnerFriend> {
  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    late StudyUser currentuser;
    getUserData(widget.user.uid).then((documentSnapshot) {
      currentuser = changetoUser(documentSnapshot);
    });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(),
      body: FutureBuilder(
          future: getFriendsData(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<StudyUser> userList = snapshot.data as List<StudyUser>;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Friends",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Spacer(),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 183, 245, 196),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LeannerApplication(
                                            user: currentuser,
                                            applicationFriends: _refreshPage,
                                          )));
                            },
                            child: const Text(
                              "Application",
                              style: TextStyle(color: Colors.black),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 232, 255, 169),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddFriendPage(
                                            currentuser: currentuser,
                                            onAddFriend: _refreshPage,
                                          )));
                            },
                            child: const Text(
                              "Add",
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (userList.isEmpty)
                          Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 150, 0, 150),
                            child: const Text('You Don\'t have Friend Yet',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 24)),
                          ),
                        if (!userList.isEmpty)
                          FriendBox(
                            userlist: userList,
                            currentuser: currentuser,
                            isadd: false,
                            onAddFriend: _refreshPage,
                            //application: null!,
                          )
                      ],
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
