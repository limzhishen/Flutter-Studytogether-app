import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/model/Course.dart';
import 'package:mae_part2_studytogether/screens/Instructor/InstructorCoursePage.dart';
import 'package:mae_part2_studytogether/screens/Instructor/InstructorCreateCourse.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/widgets/instructorcouesebox.dart';

class InstuctorCourse extends StatefulWidget {
  final User user;
  const InstuctorCourse({super.key, required this.user});

  @override
  State<InstuctorCourse> createState() => _InstuctorCourseState();
}

class _InstuctorCourseState extends State<InstuctorCourse> {
  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Container(
            child: FutureBuilder(
          future: getPersonalCourseData(widget.user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Course> personalcourse = snapshot.data as List<Course>;
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Text(
                              "Courses",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 243, 248, 183),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InstructorCreateCourse(
                                              user: widget.user,
                                            ))).then((value) {
                                  if (value) {
                                    setState(() {});
                                  }
                                });
                              },
                              child: const Text(
                                "Create Course",
                                style: TextStyle(color: Colors.black),
                              )),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(children: [
                            Container(
                              child: personalcourse.isEmpty
                                  ? const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 150, 0, 150),
                                      child: Text(
                                          'You Don\'t have create Course Yet',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 24)),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: personalcourse.length,
                                      itemBuilder: (context, index) {
                                        return Instuctorcourseswidget(
                                          course: personalcourse[index],
                                          user: widget.user,
                                          onEnroll: _refreshPage,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        InstructorCoursePage(
                                                            user: widget.user,
                                                            course: personalcourse[
                                                                index]))).then(
                                                (value) {
                                              if (value) {
                                                setState(() {});
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ]))
                    ]),
              );
            }
          },
        )));
  }
}
