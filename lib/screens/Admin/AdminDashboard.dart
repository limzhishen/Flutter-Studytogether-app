import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/model/update.dart';
import 'package:mae_part2_studytogether/model/report.dart';

class AdmDashBoardpage extends StatefulWidget {
  const AdmDashBoardpage({Key? key}) : super(key: key);

  @override
  State<AdmDashBoardpage> createState() => _AdmDashBoardpage();
}

class _AdmDashBoardpage extends State<AdmDashBoardpage> {
  late User user;
  late Future<DocumentSnapshot> userData;

  Future<DocumentSnapshot> getUserData(userid) async {
    return FirebaseFirestore.instance.collection('users').doc(userid).get();
  }

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

  Future<List<ReportData>> getReportData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('reports').get();
    List<ReportData> reportdata = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      ReportData reportData = ReportData(
          status: data['status'],
          reportID: doc.id,
          reason: data['reason'],
          reporterID: data['reporterID'],
          victimID: data['victimID']);
      reportdata.add(reportData);
    });
    return reportdata;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
            child: Column(children: [
          Column(mainAxisSize: MainAxisSize.max, children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text("Admin Dashboard",
                                style: TextStyle(
                                    fontSize: 35,
                                    fontFamily: 'Inter',
                                    decoration: TextDecoration.underline)),
                            Padding(
                              padding: EdgeInsets.all(20),
                              //
                              child: Container(
                                width: 370,
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 20, 20, 20),
                                color: Color.fromARGB(255, 255, 251, 251),
                                child: Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Reports",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: getReportData(),
                                          builder: (context, snapshot3) {
                                            if (snapshot3.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot3.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot3.error}'));
                                            } else {
                                              List<ReportData> reportData =
                                                  snapshot3.data
                                                      as List<ReportData>;
                                              if (reportData.isEmpty) {
                                                return const Text(
                                                    "No Reports Received");
                                              } else {
                                                List<ReportData> reportData =
                                                    snapshot3.data
                                                        as List<ReportData>;
                                                return ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          minHeight: 100,
                                                          maxHeight: 400),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        reportData.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      ReportData report =
                                                          reportData[index];

                                                      return FutureBuilder(
                                                        future: getUserData(
                                                            report.reporterID),
                                                        builder: (context,
                                                            snapshot4) {
                                                          if (snapshot4
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return const Center(
                                                                child:
                                                                    CircularProgressIndicator());
                                                          } else if (snapshot4
                                                              .hasError) {
                                                            return Center(
                                                                child: Text(
                                                                    'Error: ${snapshot4.error}'));
                                                          } else {
                                                            DocumentSnapshot
                                                                userData =
                                                                snapshot4.data
                                                                    as DocumentSnapshot;
                                                            if (userData
                                                                .exists) {
                                                              String
                                                                  reporterName =
                                                                  userData[
                                                                      'username'];
                                                              return FutureBuilder(
                                                                future: getUserData(
                                                                    report
                                                                        .victimID),
                                                                builder: (context,
                                                                    snapshot5) {
                                                                  if (snapshot5
                                                                          .connectionState ==
                                                                      ConnectionState
                                                                          .waiting) {
                                                                    return const Center(
                                                                        child:
                                                                            CircularProgressIndicator());
                                                                  } else if (snapshot5
                                                                      .hasError) {
                                                                    return Center(
                                                                        child: Text(
                                                                            'Error: ${snapshot5.error}'));
                                                                  } else {
                                                                    DocumentSnapshot
                                                                        victimData =
                                                                        snapshot5.data
                                                                            as DocumentSnapshot;
                                                                    if (victimData
                                                                        .exists) {
                                                                      String
                                                                          victimName =
                                                                          victimData[
                                                                              'username'];
                                                                      return ListTile(
                                                                        title: Text(
                                                                            '$reporterName reported $victimName'),
                                                                      );
                                                                    } else {
                                                                      return ListTile(
                                                                        title: Text(
                                                                            '${report.reporterID} reported ${report.victimID}'),
                                                                      );
                                                                    }
                                                                  }
                                                                },
                                                              );
                                                            } else {
                                                              return ListTile(
                                                                title: Text(
                                                                    '${report.reporterID} reported ${report.victimID}'),
                                                              );
                                                            }
                                                          }
                                                        },
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
                            Padding(
                              padding: EdgeInsets.all(20),
                              //
                              child: Container(
                                width: 370,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 20, 20, 20),
                                color: Color.fromARGB(255, 255, 251, 251),
                                child: Container(
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Latest Updates",
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: getUpdateData(),
                                          builder: (context, snapshot3) {
                                            if (snapshot3.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            } else if (snapshot3.hasError) {
                                              return Center(
                                                  child: Text(
                                                      'Error: ${snapshot3.error}'));
                                            } else {
                                              List<UpdateData> updateData =
                                                  snapshot3.data
                                                      as List<UpdateData>;
                                              if (updateData.isEmpty) {
                                                return Text(
                                                    "No have any Update");
                                              } else {
                                                List<UpdateData> updateData =
                                                    snapshot3.data
                                                        as List<UpdateData>;
                                                return ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                      minHeight: 100,
                                                      maxHeight: 400),
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        updateData.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      UpdateData update =
                                                          updateData[index];
                                                      return ListTile(
                                                        title: Text(
                                                            '${update.UpdatePath} - ${update.UpdateDescription}'),
                                                      );
                                                    },
                                                  ),
                                                );
                                                // SingleChildScrollView(
                                                //   scrollDirection:
                                                //       Axis.vertical,
                                                //   child: Column(
                                                //     children:
                                                //         updateData.map(
                                                //             (update) {
                                                //       return ListTile(
                                                //           title: Text(
                                                //         '${update.UpdatePath} - ${update.UpdateDescription}',
                                                //         style:
                                                //             const TextStyle(
                                                //           decoration:
                                                //               TextDecoration
                                                //                   .underline,
                                                //         ),
                                                //       ));
                                                //     }).toList(),
                                                //   ),
                                                // );

                                                // ConstrainedBox(
                                                //     constraints:
                                                //         BoxConstraints(
                                                //             minHeight:
                                                //                 100),
                                                //     child: ListView
                                                //         .builder(
                                                //       itemCount:
                                                //           updateData
                                                //               .length,
                                                //       itemBuilder:
                                                //           (context,
                                                //               index) {
                                                //         UpdateData
                                                //             update =
                                                //             updateData[
                                                //                 index];
                                                //         return ListTile(
                                                //           title: Text(
                                                //               '${update.UpdatePath} - ${update.UpdateDescription}'),
                                                //         );
                                                //       },
                                                //     ));
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
        ])));
  }
}
