import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/widgets/tagWidget.dart';
import 'package:mae_part2_studytogether/model/Course.dart';

import 'package:mae_part2_studytogether/model/update.dart';
import 'package:mae_part2_studytogether/widgets/BarChartWidget.dart';

class InstructorDashboard extends StatelessWidget {
  final User user;
  InstructorDashboard({Key? key, required this.user}) : super(key: key);

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

  Map<String, dynamic> getCalcaulate(List<Course> course) {
    List<double> barchartData = [0, 0, 0, 0];
    List<String> barchartname = ['', '', ''];

    course.sort((a, b) =>
        double.parse(b.joincourse).compareTo(double.parse(a.joincourse)));

    for (int i = 0; i < course.length && i < 3; i++) {
      barchartData[i + 1] = double.parse(course[i].joincourse);
      barchartname[i] = course[i].type;
    }

    barchartData[0] = barchartData[1] + barchartData[2] + barchartData[3];
    Map<String, dynamic> result = {
      'barchartData': barchartData,
      'barchartname': barchartname
    };
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<double> barchartData = [0, 0, 0, 0];
    List<String> barchartname = ['', '', ''];
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
              future: getPersonalCourseData(user.uid),
              builder: (context, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot2.hasError) {
                  return Center(child: Text('Error: ${snapshot2.error}'));
                } else {
                  List<Course> personalcourse = snapshot2.data as List<Course>;
                  if (personalcourse.isNotEmpty) {
                    Map<String, dynamic> result = getCalcaulate(personalcourse);
                    barchartname = result['barchartname'];
                    barchartData = result['barchartData'];
                  }
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
                                        height: 300,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: personalcourse.isEmpty
                                            ? const Padding(
                                                padding: EdgeInsets.all(60),
                                                child: Text(
                                                    "No Course Create Yet ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 20,
                                                      color: Colors.red,
                                                    )))
                                            : Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      'Learner Enrolled',
                                                      style: TextStyle(
                                                          fontSize: 24),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    height: 250,
                                                    child: BarChartWidget(
                                                      Data: barchartData,
                                                      nametype: barchartname,
                                                    ),
                                                  )
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
