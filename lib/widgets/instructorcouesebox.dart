import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/model/Course.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';

class Instuctorcourseswidget extends StatelessWidget {
  final Course course;
  final User user;
  final VoidCallback? onEnroll;
  final Function()? onTap;
  const Instuctorcourseswidget(
      {required this.course,
      required this.user,
      this.onEnroll,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
        child: Container(
          width: double.infinity,
          height: 130,
          decoration: BoxDecoration(
            color: Color(0xFFA9D8D9),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    course.imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      FutureBuilder(
                        future: getUserData(course.teacheruid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (!snapshot.hasData) {
                            return Text('No data found');
                          }
                          StudyUser teacher =
                              changetoUser(snapshot.data as DocumentSnapshot);

                          return Text(
                            teacher.username,
                            style: Theme.of(context).textTheme.titleMedium,
                          );
                        },
                      ),
                      Text(
                        'Price: ${course.CourseFee}/ ${course.paymenttype}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        "${course.joincourse} Joined this Course",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
