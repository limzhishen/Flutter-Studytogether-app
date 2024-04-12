import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';

class ApplicationBox extends StatefulWidget {
  final List<StudyUser> applicationlist;
  final StudyUser currentuser;
  final VoidCallback? applicationFriends;
  ApplicationBox(
      {super.key,
      required this.applicationlist,
      required this.currentuser,
      required this.applicationFriends});

  @override
  State<ApplicationBox> createState() => _ApplicationBoxState();
}

class _ApplicationBoxState extends State<ApplicationBox> {
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
            child: Text(
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
    List<StudyUser> applicationlist = widget.applicationlist;
    StudyUser currentuser = widget.currentuser;
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: 100),
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: applicationlist.length,
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
                                applicationlist[index].image_url,
                              ),
                            ),
                            Container(
                              width: 100,
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 5, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('${applicationlist[index].username}',
                                      style: TextStyle(
                                          fontSize: 24, fontFamily: 'Inter')),
                                ],
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 167, 243, 170),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () async {
                                  await currentuser
                                      .addfriends(applicationlist[index].uid);
                                  await applicationlist[index]
                                      .addfriends(currentuser.uid);
                                  await currentuser.deleteapplication(
                                      applicationlist[index].uid);
                                  await _showDialog(context, "Accept Friends",
                                      "You have accept friend ${applicationlist[index].username}");
                                  widget.applicationFriends!();
                                },
                                child: const Text(
                                  "Accept",
                                  style: TextStyle(color: Colors.black),
                                )),
                            SizedBox(
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
                                onPressed: () async {
                                  await currentuser.deleteapplication(
                                      applicationlist[index].uid);
                                  await _showDialog(
                                      context,
                                      "Delicine Friends application",
                                      "You have delicne friend ${applicationlist[index].username}");
                                  widget.applicationFriends!();
                                },
                                child: const Text(
                                  "Decline",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ]))
                    ],
                  )
                ],
              );
            }));
  }
}
