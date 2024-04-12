import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/model/Course.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/widgets/showingwidget.dart';

// heiheihei
class LearnerCoursePage extends StatefulWidget {
  final bool isenrolled;
  final Course course;
  final User user;
  final VoidCallback? onEnroll;
  const LearnerCoursePage(
      {super.key,
      required this.course,
      required this.isenrolled,
      required this.user,
      this.onEnroll});

  @override
  State<LearnerCoursePage> createState() => _LearnerCoursePageState();
}

void showdialog(
    BuildContext context, String title, String content, String button) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              button,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

class _LearnerCoursePageState extends State<LearnerCoursePage> {
  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    Course course = widget.course;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
            child: FutureBuilder(
          future: getUserData(course.teacheruid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              StudyUser teacher =
                  changetoUser(snapshot.data as DocumentSnapshot) as StudyUser;
              return Container(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                  alignment: Alignment.center,
                  child: Column(
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
                          child: Image.network(course.imageUrl),
                        ),
                        Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 30, 30, 0),
                            child: Column(children: [
                              ShowingWidget(
                                  name: "Course name",
                                  namevalue: course.name,
                                  icon: Icon(CupertinoIcons.book)),
                              ShowingWidget(
                                  name: "Course Description",
                                  namevalue: course.CourseDescription,
                                  icon: Icon(CupertinoIcons.info)),
                              ShowingWidget(
                                  name: "Course Type",
                                  namevalue: course.type,
                                  icon: Icon(CupertinoIcons.hammer)),
                              ShowingWidget(
                                  name: "Course Fee",
                                  namevalue: course.CourseFee,
                                  icon: Icon(CupertinoIcons.money_dollar)),
                              ShowingWidget(
                                  name: "Payment type",
                                  namevalue: course.paymenttype,
                                  icon: Icon(CupertinoIcons.time_solid)),
                              ShowingWidget(
                                  name: "Join Course",
                                  namevalue: course.joincourse,
                                  icon: Icon(CupertinoIcons.person_2_alt)),
                            ])),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              if (widget.isenrolled) {
                                return Colors.green;
                              } else {
                                return const Color.fromARGB(255, 249, 245, 214);
                              }
                            }),
                          ),
                          onPressed: widget.isenrolled
                              ? () async {
                                  await FirebaseFirestore.instance
                                      .collection('enrroledcourse')
                                      .doc(user.uid)
                                      .set({course.courseuid: course.courseuid},
                                          SetOptions(merge: true)).then((_) {
                                    if (widget.onEnroll != null) {
                                      widget.onEnroll!();
                                    }
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('course')
                                      .doc(course.courseuid)
                                      .update({
                                    'joincourse':
                                        (int.parse(course.joincourse) + 1)
                                            .toString()
                                  });
                                  DocumentSnapshot userRoom =
                                      await FirebaseFirestore.instance
                                          .collection('chatRooms')
                                          .doc(user.uid)
                                          .get();

                                  if (userRoom.exists == false) {
                                    await FirebaseFirestore.instance
                                        .collection('chatRooms')
                                        .doc(user.uid)
                                        .set({
                                      'chatRoomsID': [],
                                    });
                                  }
                                  List<dynamic> insChatRoomsID;

                                  if (userRoom.exists) {
                                    insChatRoomsID = userRoom['chatRoomsID'];
                                  } else {
                                    insChatRoomsID = [];
                                  }
                                  DocumentSnapshot newDocRef =
                                      await FirebaseFirestore.instance
                                          .collection('course')
                                          .doc(course.courseuid)
                                          .get();
                                  String newChatRoomID =
                                      newDocRef['chatRoomID'];

                                  insChatRoomsID.add(newChatRoomID);

                                  await FirebaseFirestore.instance
                                      .collection('chatRooms')
                                      .doc(user.uid)
                                      .update({
                                    'chatRoomsID': insChatRoomsID,
                                  });
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Enrolled course"),
                                      content: Text(
                                          "Success to join to course ${course.name}"),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            "Ok",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              : () {
                                  showdialog(
                                      context,
                                      'Coming Soon',
                                      "This Function is in Contribution",
                                      "Be Paitient");
                                },
                          child: widget.isenrolled
                              ? const Text("Enrolled")
                              : const Text(
                                  "Content",
                                  style: TextStyle(color: Colors.black),
                                ),
                        ),
                      ]));
            }
          },
        )));
  }
}
