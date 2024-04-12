import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/model/Course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminCourses extends StatefulWidget {
  const AdminCourses({Key? key}) : super(key: key);

  @override
  State<AdminCourses> createState() => _AdminCoursesState();
}

class _AdminCoursesState extends State<AdminCourses> {
  void _refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  Text("All Courses",
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'Inter',
                          decoration: TextDecoration.underline)),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: courses.map((course) {
                          String Price = course.CourseFee;
                          String paymentType = course.paymenttype;
                          String joinCount = course.joincourse;
                          String totalRevenue =
                              (int.parse(Price) * int.parse(joinCount))
                                  .toString();
                          return Column(children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFA9D8D9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.network(
                                            course.imageUrl,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                course.name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6,
                                              ),
                                              FutureBuilder<DocumentSnapshot>(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(course.teacheruid)
                                                    .get(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  }
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  }
                                                  if (!snapshot.hasData) {
                                                    return Text(
                                                        'No data found');
                                                  }
                                                  var data = snapshot.data!
                                                          .data()
                                                      as Map<String, dynamic>;
                                                  var username =
                                                      data['username'];
                                                  return Text(
                                                    'Teacher: $username',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                  );
                                                },
                                              ),
                                              Text(
                                                  'Price: RM $Price/$paymentType',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2),
                                              Text(
                                                  '$joinCount Joined this Course',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2),
                                              Text(
                                                  'Total Revenue: RM $totalRevenue',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                            )
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
