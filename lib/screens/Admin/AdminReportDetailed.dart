import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';

class AdmReportDetailedPage extends StatefulWidget {
  const AdmReportDetailedPage({Key? key, required this.reportID})
      : super(key: key);
  final String reportID;
  @override
  State<AdmReportDetailedPage> createState() => _AdmReportDetailedPageState();
}

class _AdmReportDetailedPageState extends State<AdmReportDetailedPage> {
  late User user;
  late Future<DocumentSnapshot> userData;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<DocumentSnapshot> getUserData(userid) async {
    return FirebaseFirestore.instance.collection('users').doc(userid).get();
  }

  Future<DocumentSnapshot> getReportData() async {
    return FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.reportID)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: getReportData(),
                builder: (context, snapshot1) {
                  if (snapshot1.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot1.hasError) {
                    return Center(child: Text('Error: ${snapshot1.error}'));
                  } else {
                    DocumentSnapshot reportData =
                        snapshot1.data as DocumentSnapshot;
                    String ReportReason = reportData['reason'];
                    String ReporterID = reportData['reporterID'];
                    String VictimID = reportData['victimID'];
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                            future: getUserData(ReporterID),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot2.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot2.error}'));
                              } else {
                                DocumentSnapshot reporterData =
                                    snapshot2.data as DocumentSnapshot;
                                String ReporterName = reporterData['username'];
                                String ReporterIMG = reporterData['image_url'];
                                return Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FutureBuilder(
                                          future: getUserData(VictimID),
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
                                              DocumentSnapshot victimData =
                                                  snapshot3.data
                                                      as DocumentSnapshot;
                                              String VictimName =
                                                  victimData['username'];
                                              String VictimIMG =
                                                  victimData['image_url'];
                                              return Container(
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                  alignment: Alignment.center,
                                                  child: Column(children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Reporter',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headlineLarge
                                                                      ?.copyWith(
                                                                        decoration:
                                                                            TextDecoration.underline,
                                                                      ),
                                                                ),
                                                                Container(
                                                                  width: 100,
                                                                  height: 100,
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Image
                                                                      .network(
                                                                    ReporterIMG,
                                                                  ),
                                                                ),
                                                                Text(
                                                                    ReporterName,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headlineLarge),
                                                              ]),
                                                          Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  'Victim',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headlineLarge
                                                                      ?.copyWith(
                                                                        decoration:
                                                                            TextDecoration.underline,
                                                                      ),
                                                                ),
                                                                Container(
                                                                  width: 100,
                                                                  height: 100,
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                  child: Image
                                                                      .network(
                                                                    VictimIMG,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  VictimName,
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headlineLarge,
                                                                ),
                                                              ])
                                                        ]),
                                                    Text(
                                                      'Reason of Report',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineLarge
                                                          ?.copyWith(
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                    ),
                                                    Text(ReportReason,
                                                        textAlign:
                                                            TextAlign.justify,
                                                        style: const TextStyle(
                                                          fontFamily: 'Inter',
                                                          fontSize: 22,
                                                        )),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SizedBox(
                                                            width: 180,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                DocumentSnapshot
                                                                    reportData =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "reports")
                                                                        .doc(widget
                                                                            .reportID)
                                                                        .get();
                                                                String
                                                                    ReportStatus =
                                                                    reportData[
                                                                        'status'];

                                                                if (ReportStatus ==
                                                                    "OPEN") {
                                                                  print(
                                                                      "Report is OPEN");
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(
                                                                          VictimID)
                                                                      .update({
                                                                    'status':
                                                                        "BAN",
                                                                  });
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'reports')
                                                                      .doc(widget
                                                                          .reportID)
                                                                      .update({
                                                                    'status':
                                                                        "CLOSED",
                                                                  });
                                                                  showDialog(
                                                                    // ignore: use_build_context_synchronously
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                      title: const Text(
                                                                          "Victim has been BANNED"),
                                                                      content:
                                                                          const Text(
                                                                              "The Victim has been banned successfully"),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.black),
                                                                          ),
                                                                          child:
                                                                              const Text("OK"),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                } else if (ReportStatus ==
                                                                    "CLOSED") {
                                                                  showDialog(
                                                                    // ignore: use_build_context_synchronously
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                      title: const Text(
                                                                          "Action Failed"),
                                                                      content:
                                                                          const Text(
                                                                              "The Report is already CLOSED, no further action can be done."),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.black),
                                                                          ),
                                                                          child:
                                                                              const Text("OK"),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Colors.red[
                                                                            400]),
                                                              ),
                                                              child: const Text(
                                                                "Ban Victim",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 180,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                DocumentSnapshot
                                                                    reportData =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "reports")
                                                                        .doc(widget
                                                                            .reportID)
                                                                        .get();
                                                                String
                                                                    ReportStatus =
                                                                    reportData[
                                                                        'status'];
                                                                DocumentSnapshot
                                                                    victimData =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            VictimID)
                                                                        .get();
                                                                String
                                                                    victimStatus =
                                                                    victimData[
                                                                        'status'];
                                                                String
                                                                    actionTaken =
                                                                    'NULL';
                                                                if (ReportStatus ==
                                                                    "OPEN") {
                                                                  if (victimStatus ==
                                                                      "WARN") {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            VictimID)
                                                                        .update({
                                                                      'status':
                                                                          "BAN",
                                                                    });
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'reports')
                                                                        .doc(widget
                                                                            .reportID)
                                                                        .update({
                                                                      'status':
                                                                          "CLOSED",
                                                                    });
                                                                    actionTaken =
                                                                        "BANNED";
                                                                  } else if (victimStatus ==
                                                                      "OK") {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            VictimID)
                                                                        .update({
                                                                      'status':
                                                                          "WARN",
                                                                    });
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'reports')
                                                                        .doc(widget
                                                                            .reportID)
                                                                        .update({
                                                                      'status':
                                                                          "CLOSED",
                                                                    });
                                                                    actionTaken =
                                                                        "WARNED";
                                                                  }
                                                                  showDialog(
                                                                    // ignore: use_build_context_synchronously
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                      title: Text(
                                                                          "Victim has been $actionTaken"),
                                                                      content: Text(
                                                                          "The Victim has been $actionTaken successfully"),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.black),
                                                                          ),
                                                                          child:
                                                                              const Text("OK"),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                } else if (ReportStatus ==
                                                                    "CLOSED") {
                                                                  showDialog(
                                                                    // ignore: use_build_context_synchronously
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                      title: const Text(
                                                                          "Action Failed"),
                                                                      content:
                                                                          const Text(
                                                                              "The Report is already CLOSED, no further action can be done."),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.black),
                                                                          ),
                                                                          child:
                                                                              const Text("OK"),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Colors.red[
                                                                            200]),
                                                              ),
                                                              child: const Text(
                                                                "Warn Victim",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SizedBox(
                                                            width: 180,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                DocumentSnapshot
                                                                    reportData =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "reports")
                                                                        .doc(widget
                                                                            .reportID)
                                                                        .get();
                                                                String
                                                                    ReportStatus =
                                                                    reportData[
                                                                        'status'];
                                                                DocumentSnapshot
                                                                    ReporterData =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            ReporterID)
                                                                        .get();
                                                                String
                                                                    reporterStatus =
                                                                    ReporterData[
                                                                        'status'];

                                                                if (ReportStatus ==
                                                                    "OPEN") {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'users')
                                                                      .doc(
                                                                          ReporterID)
                                                                      .update({
                                                                    'status':
                                                                        "BAN",
                                                                  });
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'reports')
                                                                      .doc(widget
                                                                          .reportID)
                                                                      .update({
                                                                    'status':
                                                                        "CLOSED",
                                                                  });
                                                                  showDialog(
                                                                    // ignore: use_build_context_synchronously
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                      title: const Text(
                                                                          "Reporter has been BANNED"),
                                                                      content:
                                                                          const Text(
                                                                              "The Reporter has been banned successfully"),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.black),
                                                                          ),
                                                                          child:
                                                                              const Text("OK"),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                } else if (ReportStatus ==
                                                                    "CLOSED") {
                                                                  showDialog(
                                                                    // ignore: use_build_context_synchronously
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                      title: const Text(
                                                                          "Action Failed"),
                                                                      content:
                                                                          const Text(
                                                                              "The Report is already CLOSED, no further action can be done."),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.black),
                                                                          ),
                                                                          child:
                                                                              const Text("OK"),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Colors.red[
                                                                            400]),
                                                              ),
                                                              child: const Text(
                                                                "Ban Reporter",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 180,
                                                            child:
                                                                ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                DocumentSnapshot
                                                                    reportData =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "reports")
                                                                        .doc(widget
                                                                            .reportID)
                                                                        .get();
                                                                String
                                                                    ReportStatus =
                                                                    reportData[
                                                                        'status'];

                                                                DocumentSnapshot
                                                                    ReporterData =
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            ReporterID)
                                                                        .get();
                                                                String
                                                                    reporterStatus =
                                                                    ReporterData[
                                                                        'status'];
                                                                String
                                                                    actionTaken =
                                                                    'NULL';
                                                                if (ReportStatus ==
                                                                    "OPEN") {
                                                                  if (reporterStatus ==
                                                                      "WARN") {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            ReporterID)
                                                                        .update({
                                                                      'status':
                                                                          "BAN",
                                                                    });
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'reports')
                                                                        .doc(widget
                                                                            .reportID)
                                                                        .update({
                                                                      'status':
                                                                          "CLOSED",
                                                                    });
                                                                    actionTaken =
                                                                        "BANNED";
                                                                  } else if (reporterStatus ==
                                                                      "OK") {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'users')
                                                                        .doc(
                                                                            ReporterID)
                                                                        .update({
                                                                      'status':
                                                                          "WARN",
                                                                    });
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'reports')
                                                                        .doc(widget
                                                                            .reportID)
                                                                        .update({
                                                                      'status':
                                                                          "CLOSED",
                                                                    });
                                                                    actionTaken =
                                                                        "WARNED";
                                                                  }
                                                                  showDialog(
                                                                    // ignore: use_build_context_synchronously
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                      title: Text(
                                                                          "Reporter has been $actionTaken"),
                                                                      content: Text(
                                                                          "The Reporter has been $actionTaken successfully"),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.black),
                                                                          ),
                                                                          child:
                                                                              const Text("OK"),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                } else if (ReportStatus ==
                                                                    "CLOSED") {
                                                                  showDialog(
                                                                    // ignore: use_build_context_synchronously
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            AlertDialog(
                                                                      title: const Text(
                                                                          "Action Failed"),
                                                                      content:
                                                                          const Text(
                                                                              "The Report is already CLOSED, no further action can be done."),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Navigator.pop(context),
                                                                          style:
                                                                              ButtonStyle(
                                                                            backgroundColor:
                                                                                MaterialStateProperty.all(Colors.black),
                                                                          ),
                                                                          child:
                                                                              const Text("OK"),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty.all(
                                                                        Colors.red[
                                                                            200]),
                                                              ),
                                                              child: const Text(
                                                                "Warn Reporter",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SizedBox(
                                                          width: 330,
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              DocumentSnapshot
                                                                  reportData =
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "reports")
                                                                      .doc(widget
                                                                          .reportID)
                                                                      .get();
                                                              String
                                                                  ReportStatus =
                                                                  reportData[
                                                                      'status'];

                                                              if (ReportStatus ==
                                                                  "OPEN") {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'reports')
                                                                    .doc(widget
                                                                        .reportID)
                                                                    .update({
                                                                  'status':
                                                                      "CLOSED",
                                                                });
                                                                showDialog(
                                                                  // ignore: use_build_context_synchronously
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: const Text(
                                                                        "Report Closed Confirmation"),
                                                                    content:
                                                                        const Text(
                                                                            "The report has successfully been closed."),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(Colors.black),
                                                                        ),
                                                                        child: const Text(
                                                                            "OK"),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              } else if (ReportStatus ==
                                                                  "CLOSED") {
                                                                showDialog(
                                                                  // ignore: use_build_context_synchronously
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: const Text(
                                                                        "Failed to Close Report"),
                                                                    content:
                                                                        const Text(
                                                                            "The Report is already CLOSED."),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        style:
                                                                            ButtonStyle(
                                                                          backgroundColor:
                                                                              MaterialStateProperty.all(Colors.black),
                                                                        ),
                                                                        child: const Text(
                                                                            "OK"),
                                                                      )
                                                                    ],
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                              .green[
                                                                          300]),
                                                            ),
                                                            child: const Text(
                                                              "Close Report",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ]));
                                            }
                                          })
                                    ]);
                              }
                            }),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
