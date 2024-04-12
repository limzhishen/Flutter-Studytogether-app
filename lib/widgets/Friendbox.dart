import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/screens/Learner/LearnerDetailsFriends.dart';

class FriendBox extends StatelessWidget {
  final List<StudyUser> userlist;
  final StudyUser currentuser;
  final bool isadd;
  final VoidCallback? onAddFriend;

  const FriendBox({
    super.key,
    required this.userlist,
    required this.currentuser,
    required this.isadd,
    required this.onAddFriend,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 100),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: userlist.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                              ),
                              child: Image.network(
                                userlist[index].image_url,
                              ),
                            ),
                            Container(
                              width: 200,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 5, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('${userlist[index].username}',
                                      style: const TextStyle(
                                          fontSize: 30, fontFamily: 'Inter')),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(100, 50, 117, 131),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.outbound_sharp),
                                iconSize: 40,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LeaarnnerDetailsFriend(
                                          userData: userlist[index],
                                          currentuser: currentuser,
                                          isadd: isadd,
                                        ),
                                      )).then((value) {
                                    if (value) {
                                      if (value == true) {
                                        onAddFriend!();
                                      }
                                      ;
                                    }
                                  });
                                },
                              ),
                            ),
                          ]))
                    ],
                  )
                ],
              );
            }));
  }
}
