import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/model/report.dart';
import 'package:mae_part2_studytogether/screens/Admin/AdminReportDetailed.dart';

class AdmReportsPage extends StatefulWidget {
  const AdmReportsPage({Key? key}) : super(key: key);

  @override
  State<AdmReportsPage> createState() => _AdmReportsPageState();
}

class _AdmReportsPageState extends State<AdmReportsPage> {
  late User user;
  late Future<DocumentSnapshot> userData;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<DocumentSnapshot> getUserData(userid) async {
    return FirebaseFirestore.instance.collection('users').doc(userid).get();
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
          const Text("Reports",
              style: TextStyle(
                  fontSize: 35,
                  fontFamily: 'Inter',
                  decoration: TextDecoration.underline)),
          FutureBuilder(
              future: getReportData(),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot1.hasError) {
                  return Center(child: Text('Error: ${snapshot1.error}'));
                } else {
                  List<ReportData> reportData =
                      snapshot1.data as List<ReportData>;
                  return Container(
                      height: MediaQuery.of(context).size.height - 170,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: reportData.length,
                          itemBuilder: (context, index) {
                            ReportData report = reportData[index];
                            String reporterID = report.reporterID;
                            String reportIndex = (index + 1).toString();
                            String reportStatus = report.status;
                            return FutureBuilder(
                                future: getUserData(report.reporterID),
                                builder: (context, snapshot4) {
                                  if (snapshot4.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot4.hasError) {
                                    return Center(
                                        child:
                                            Text('Error: ${snapshot4.error}'));
                                  } else {
                                    DocumentSnapshot userData =
                                        snapshot4.data as DocumentSnapshot;
                                    String reporterName = userData['username'];
                                    return FutureBuilder(
                                        future: getUserData(report.victimID),
                                        builder: (context, snapshot5) {
                                          if (snapshot5.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot5.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot5.error}'));
                                          } else {
                                            DocumentSnapshot victimData =
                                                snapshot5.data
                                                    as DocumentSnapshot;
                                            String victimName =
                                                victimData['username'];
                                            return Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .black),
                                                                color: switch (
                                                                    reportStatus) {
                                                                  'CLOSED' =>
                                                                    Colors.green[
                                                                        200],
                                                                  _ => Color(
                                                                      0xFFE0F4F5),
                                                                }),
                                                        child: Row(children: [
                                                          Container(
                                                            width: 300,
                                                            child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            12,
                                                                            3,
                                                                            0,
                                                                            3),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        'Report #$reportIndex | [$reportStatus]',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                25,
                                                                            fontFamily:
                                                                                'Inter',
                                                                            decoration:
                                                                                TextDecoration.underline)),
                                                                    Text(
                                                                        'Reporter: $reporterName',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontFamily:
                                                                                'Inter')),
                                                                    Text(
                                                                        'Victim: $victimName',
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontFamily:
                                                                                'Inter')),
                                                                  ],
                                                                )),
                                                          ),
                                                          Expanded(
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child:
                                                                    Container(
                                                                  width: 75,
                                                                  height: 75,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        100,
                                                                        50,
                                                                        117,
                                                                        131),
                                                                    shape: BoxShape
                                                                        .rectangle,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child:
                                                                      IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .outbound_sharp),
                                                                    iconSize:
                                                                        40,
                                                                    onPressed:
                                                                        () {
                                                                      Navigator
                                                                          .push(
                                                                              context,
                                                                              MaterialPageRoute(
                                                                                builder: (context) => AdmReportDetailedPage(
                                                                                  reportID: report.reportID,
                                                                                ),
                                                                              )).then(
                                                                          (_) =>
                                                                              setState(() {}));
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ]))
                                                  ],
                                                )
                                              ],
                                            );
                                          }
                                        });
                                  }
                                });
                          }));
                }
              })
        ]),
      ),
    );
  }
}
