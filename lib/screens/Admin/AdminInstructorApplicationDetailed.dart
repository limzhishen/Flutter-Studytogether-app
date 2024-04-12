import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/widgets/showingwidget.dart';
import 'package:flutter/cupertino.dart';

class AdmInstApplicationDetailed extends StatefulWidget {
  const AdmInstApplicationDetailed({Key? key, required this.instructorID})
      : super(key: key);
  final String instructorID;

  @override
  State<AdmInstApplicationDetailed> createState() =>
      _AdmInstApplicationDetailedState();
}

class _AdmInstApplicationDetailedState
    extends State<AdmInstApplicationDetailed> {
  late User user;
  late Future<DocumentSnapshot> userData;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<DocumentSnapshot> getApplicationData(appID) async {
    return FirebaseFirestore.instance
        .collection('applications')
        .doc(appID)
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
                      const Text("Insturctor Application",
                          style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'Inter',
                              decoration: TextDecoration.underline)),
                      FutureBuilder(
                          future: getApplicationData(widget.instructorID),
                          builder: (context, snapshot1) {
                            if (snapshot1.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot1.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot1.error}'));
                            } else {
                              StudyUser userData = changetoUser(
                                  snapshot1.data as DocumentSnapshot);
                              return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Column(children: [
                                          Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 100,
                                                  height: 100,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Image.network(
                                                      userData.image_url),
                                                ),
                                                Text(userData.username,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge),
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: 130,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(widget
                                                              .instructorID)
                                                          .set({
                                                        'username':
                                                            userData.username,
                                                        'email': userData.email,
                                                        'image_url':
                                                            userData.image_url,
                                                        'userrole':
                                                            "Instructor",
                                                        'phonenumber': userData
                                                            .phonenumber,
                                                        'tag1': '',
                                                        'tag2': '',
                                                        'tag3': '',
                                                        'status': 'OK',
                                                        'password':
                                                            userData.password,
                                                        'uid': userData.uid
                                                      });
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'applications')
                                                          .doc(widget
                                                              .instructorID)
                                                          .delete();
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .green[400]),
                                                    ),
                                                    child: const Text("Approve",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 130,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'applications')
                                                          .doc(widget
                                                              .instructorID)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .red[300]),
                                                    ),
                                                    child: const Text("Reject",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20)),
                                                  ),
                                                )
                                              ]),
                                          Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(20, 30, 0, 0),
                                              child: Column(children: [
                                                ShowingWidget(
                                                    name: "Userrole",
                                                    namevalue:
                                                        userData.userrole,
                                                    icon: const Icon(
                                                        CupertinoIcons
                                                            .person_solid)),
                                                ShowingWidget(
                                                    name: "Username",
                                                    namevalue:
                                                        userData.username,
                                                    icon: const Icon(
                                                        CupertinoIcons.person)),
                                                ShowingWidget(
                                                    name: "Email",
                                                    namevalue: userData.email,
                                                    icon: const Icon(
                                                        CupertinoIcons.mail)),
                                                ShowingWidget(
                                                    name: "Phone Number",
                                                    namevalue:
                                                        userData.phonenumber,
                                                    icon: const Icon(
                                                        CupertinoIcons.phone)),
                                                ShowingWidget(
                                                    name: "Status",
                                                    namevalue: userData.status,
                                                    icon: const Icon(
                                                        CupertinoIcons.star)),
                                              ]))
                                        ])),
                                  ]);
                            }
                          })
                    ]))));
  }
}
