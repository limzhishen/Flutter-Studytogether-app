import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/widgets/showingwidget.dart';
import 'package:flutter/cupertino.dart';

class AdmUserDetailedPage extends StatefulWidget {
  const AdmUserDetailedPage({Key? key, required this.userID}) : super(key: key);
  final String userID;

  @override
  State<AdmUserDetailedPage> createState() => _AdmUserDetailedPageState();
}

class _AdmUserDetailedPageState extends State<AdmUserDetailedPage> {
  late User user;
  late Future<DocumentSnapshot> userData;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<DocumentSnapshot> getUserData(userid) async {
    return FirebaseFirestore.instance.collection('users').doc(userid).get();
  }

  Future<DocumentSnapshot> getReportData() async {
    return FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.userID)
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
                          future: getUserData(widget.userID),
                          builder: (context, snapshot1) {
                            if (snapshot1.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot1.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot1.error}'));
                            } else {
                              DocumentSnapshot userData =
                                  snapshot1.data as DocumentSnapshot;
                              String userName = userData['username'];
                              String userEmail = userData['email'];
                              String userRole = userData['userrole'];
                              String userPhoneNumber = userData['phonenumber'];
                              String userImageLink = userData['image_url'];
                              String userStatus = userData['status'];
                              return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).size.height +
                                                40,
                                        alignment: Alignment.center,
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
                                                      userImageLink),
                                                ),
                                                Text(userRole,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineLarge
                                                        ?.copyWith(
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        )),
                                                Text(userName,
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
                                                      DocumentSnapshot
                                                          UserData =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(
                                                                  widget.userID)
                                                              .get();
                                                      String userStatus =
                                                          UserData['status'];

                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(widget.userID)
                                                          .update({
                                                        'status': "BAN",
                                                      });
                                                      showDialog(
                                                        // ignore: use_build_context_synchronously
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: const Text(
                                                              "User has been BANNED"),
                                                          content: const Text(
                                                              "The User has been BANNED successfully"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text("OK"),
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                            .black),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ).then((_) =>
                                                          setState(() {}));
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .red[400]),
                                                    ),
                                                    child: const Text("Ban",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 130,
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      DocumentSnapshot
                                                          UserData =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(
                                                                  widget.userID)
                                                              .get();
                                                      String userStatus =
                                                          UserData['status'];
                                                      String executionType = '';
                                                      if (userStatus == "OK") {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(widget.userID)
                                                            .update({
                                                          'status': "WARN",
                                                        });
                                                        executionType =
                                                            "WARNED";
                                                      } else {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(widget.userID)
                                                            .update({
                                                          'status': "BAN",
                                                        });
                                                        executionType =
                                                            "BANNED";
                                                      }
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              "User has been $executionType"),
                                                          content: Text(
                                                              "The User has been $executionType successfully"),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text("OK"),
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    MaterialStateProperty
                                                                        .all(Colors
                                                                            .black),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ).then((_) =>
                                                          setState(() {}));
                                                    },
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all(Colors
                                                                  .red[200]),
                                                    ),
                                                    child: const Text("Warn",
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
                                                    namevalue: userRole,
                                                    icon: const Icon(
                                                        CupertinoIcons
                                                            .person_solid)),
                                                ShowingWidget(
                                                    name: "Username",
                                                    namevalue: userName,
                                                    icon: const Icon(
                                                        CupertinoIcons.person)),
                                                ShowingWidget(
                                                    name: "Email",
                                                    namevalue: userEmail,
                                                    icon: const Icon(
                                                        CupertinoIcons.mail)),
                                                ShowingWidget(
                                                    name: "Phone Number",
                                                    namevalue: userPhoneNumber,
                                                    icon: const Icon(
                                                        CupertinoIcons.phone)),
                                                ShowingWidget(
                                                    name: "Status",
                                                    namevalue: userStatus,
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
