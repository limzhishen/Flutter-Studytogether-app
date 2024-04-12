import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/screens/Learner/LearnerCoursePage.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/model/Course.dart';
import 'package:mae_part2_studytogether/widgets/boxWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mae_part2_studytogether/widgets/tagdropwidget.dart';
import 'package:mae_part2_studytogether/model/Coursetype.dart';

class LearnerJoinCourse extends StatefulWidget {
  final User user;
  LearnerJoinCourse({Key? key, required this.user}) : super(key: key);

  @override
  State<LearnerJoinCourse> createState() => _LeanerJoinCourseState();
}

List<Course> getfilter(List<Course> unfilterdata, String coursetype) {
  if (coursetype == '') {
    return unfilterdata;
  }
  unfilterdata.removeWhere((element) {
    return element.type != coursetype;
  });
  return unfilterdata;
}

class _LeanerJoinCourseState extends State<LearnerJoinCourse> {
  String cousefiltertype = '';

  void _refreshPage() {
    setState(() {
      cousefiltertype = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(),
      body: FutureBuilder<List<Course>>(
        future: getCourseAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Course> courses = snapshot.data as List<Course>;
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('enrroledcourse')
                    .doc(user.uid)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text('No data found'));
                  } else {
                    if (snapshot != null && snapshot.data != null) {
                      DocumentSnapshot enroled =
                          snapshot.data as DocumentSnapshot;
                      Map<String, dynamic>? enrolledCourseData =
                          enroled.data() as Map<String, dynamic>?;
                      if (enrolledCourseData != null) {
                        courses.removeWhere((course) {
                          return enrolledCourseData!.keys
                              .contains(course.courseuid);
                        });
                      }
                    }

                    List<Course> filtercouse =
                        getfilter(courses, cousefiltertype);
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(children: [
                                  Text(
                                    'Join Courses',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                  ),
                                  Spacer(),
                                  tagdropWidget3(
                                    tagvalue: cousefiltertype,
                                    item: courseTypes,
                                    isedit: false,
                                    onChanged: (value) {
                                      setState(() {
                                        cousefiltertype = value!;
                                      });
                                    },
                                  )
                                ]),
                                courses.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Center(
                                          child: Text(
                                            'No More course for enrolled',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                          itemCount: courses.length,
                                          itemBuilder: (context, index) {
                                            return BoxWidget(
                                              course: courses[index],
                                              user: user,
                                              onEnroll: _refreshPage,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) =>
                                                            LearnerCoursePage(
                                                              course: courses[
                                                                  index],
                                                              user: user,
                                                              onEnroll:
                                                                  _refreshPage,
                                                              isenrolled: true,
                                                            )));
                                              },
                                            );
                                          },
                                        ),
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                });
          }
        },
      ),
    );
  }
}
