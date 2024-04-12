import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/widgets/tagWidget.dart';
import 'package:mae_part2_studytogether/model/Course.dart';
import 'package:mae_part2_studytogether/widgets/caroslider.dart';
import 'package:mae_part2_studytogether/model/update.dart';

class LearnerDashBoardpage extends StatelessWidget {
  LearnerDashBoardpage({Key? key, required this.user}) : super(key: key);
  late User user;

  Future<List<UpdateData>> getUpdateData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('update').get();
    List<UpdateData> updatedata = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      UpdateData updateData = UpdateData(
          UpdatePath: data['UpdatePath'],
          UpdateDescription: data['UpdateDescription']);
      updatedata.add(updateData);
    });

    return updatedata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(),
      body: FutureBuilder(
        future: getUserData(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            StudyUser userData =
                changetoUser(snapshot.data as DocumentSnapshot);
            return FutureBuilder(
              future: userData.getCourseData(),
              builder: (context, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot2.hasError) {
                  return Center(child: Text('Error: ${snapshot2.error}'));
                } else {
                  List<Course> courses = snapshot2.data as List<Course>;

                  return SingleChildScrollView(
                      child: Column(children: [
                    Column(mainAxisSize: MainAxisSize.max, children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Dashboard',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge,
                                      ),
                                      Container(
                                        width: 100,
                                        height: 100,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          userData.image_url ?? '',
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 0, 0),
                                        child: Text(userData.username,
                                            style: const TextStyle(
                                                fontSize: 30,
                                                fontFamily: 'Inter')),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 10, 0, 20),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (userData.tag1 != '')
                                                TagWidget(
                                                  text: userData.tag1,
                                                ),
                                              SizedBox(width: 20),
                                              if (userData.tag2 != '')
                                                TagWidget(
                                                  text: userData.tag2,
                                                ),
                                              SizedBox(width: 20),
                                              if (userData.tag3 != '')
                                                TagWidget(
                                                  text: userData.tag3,
                                                ),
                                            ]),
                                      ),
                                      Container(
                                        width: 350,
                                        height: 250,
                                        decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 233, 232, 232),
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(children: [
                                                Text('Enrolled Courses',
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 20,
                                                        decoration:
                                                            TextDecoration
                                                                .underline)),
                                              ]),
                                            ),
                                            Container(
                                                width: double.infinity,
                                                height: 180,
                                                child: courses != null
                                                    ? CourseCarousel(
                                                        courses: courses,
                                                        user: user,
                                                      )
                                                    : const Text(
                                                        'No enrolled courses yet.',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 20,
                                                          color: Colors.red,
                                                        ),
                                                      ))
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(20),
                                        //
                                        child: Container(
                                          width: 370,
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(20, 20, 20, 20),
                                          color: const Color.fromARGB(
                                              255, 255, 251, 251),
                                          child: Container(
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Latest Updates",
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  FutureBuilder(
                                                    future: getUpdateData(),
                                                    builder:
                                                        (context, snapshot3) {
                                                      if (snapshot3
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Center(
                                                            child:
                                                                CircularProgressIndicator());
                                                      } else if (snapshot3
                                                          .hasError) {
                                                        return Center(
                                                            child: Text(
                                                                'Error: ${snapshot3.error}'));
                                                      } else {
                                                        List<UpdateData>
                                                            updateData =
                                                            snapshot3.data
                                                                as List<
                                                                    UpdateData>;
                                                        if (updateData
                                                            .isEmpty) {
                                                          return const Text(
                                                              "No have any Update");
                                                        } else {
                                                          List<UpdateData>
                                                              updateData =
                                                              snapshot3.data
                                                                  as List<
                                                                      UpdateData>;
                                                          return ConstrainedBox(
                                                            constraints:
                                                                const BoxConstraints(
                                                                    minHeight:
                                                                        100,
                                                                    maxHeight:
                                                                        400),
                                                            child: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  updateData
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                UpdateData
                                                                    update =
                                                                    updateData[
                                                                        index];
                                                                return ListTile(
                                                                  title: Text(
                                                                      '${update.UpdatePath} - ${update.UpdateDescription}'),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ],
                                              )),
                                        ),
                                        //
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ])
                  ]));
                }
              },
            );
          }
        },
      ),
    );
  }
}
