import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/screens/Admin/AdminInstructorApplicationDetailed.dart';

class AdminInstructorApprovals extends StatefulWidget {
  const AdminInstructorApprovals({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminInstructorApprovals> createState() =>
      _AdminInstructorApprovalsState();
}

class ApplicationList {
  final String name;
  final String imgLink;
  final String userID;

  ApplicationList(
      {required this.name, required this.imgLink, required this.userID});
}

class _AdminInstructorApprovalsState extends State<AdminInstructorApprovals> {
  late User user;
  late Future<DocumentSnapshot> userData;

  void onInstructorApprovalChanged() {
    setState(() {
      // Refresh the data in your main page
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<ApplicationList>> getApplData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('applications').get();
    List<ApplicationList> userList = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      ApplicationList updateData = ApplicationList(
          userID: doc.id, name: data['username'], imgLink: data['image_url']);
      userList.add(updateData);
    });
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 3, 0, 3),
                  child: Row(children: [
                    Text("Instructor Applications",
                        style: Theme.of(context).textTheme.headlineLarge),
                  ])),
              FutureBuilder(
                  future: getApplData(),
                  builder: (context, snapshot1) {
                    if (snapshot1.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot1.hasError) {
                      return Center(child: Text('Error: ${snapshot1.error}'));
                    } else {
                      List<ApplicationList> userlist =
                          snapshot1.data as List<ApplicationList>;
                      if (userlist.isEmpty) {
                        return const Center(
                            child: Text(
                          'No Instructor Applications',
                        ));
                      } else {
                        return Container(
                            height: MediaQuery.of(context).size.height - 170,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: userlist.length,
                                itemBuilder: (context, index) {
                                  ApplicationList user = userlist[index];
                                  String userName = user.name;
                                  String imgLink = user.imgLink;
                                  String userID = user.userID;
                                  return Column(
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                              ),
                                              child: Row(children: [
                                                Container(
                                                  width: 70,
                                                  height: 70,
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(5, 0, 5, 0),
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                  ),
                                                  child: Image.network(
                                                    imgLink,
                                                  ),
                                                ),
                                                Container(
                                                  width: 200,
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(
                                                          10, 0, 5, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(userName,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 25,
                                                                  fontFamily:
                                                                      'Inter')),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: 75,
                                                        height: 75,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(100, 50,
                                                              117, 131),
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child: IconButton(
                                                          icon: const Icon(Icons
                                                              .outbound_sharp),
                                                          iconSize: 40,
                                                          onPressed: () {
                                                            Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              AdmInstApplicationDetailed(
                                                                        instructorID:
                                                                            userID,
                                                                      ),
                                                                    ))
                                                                .then((_) =>
                                                                    setState(
                                                                        () {}));
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
                                }));
                      }
                    }
                  })
            ],
          ),
        ));
  }
}
