import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/screens/Admin/AdminInstructorApprovals.dart';
import 'package:mae_part2_studytogether/screens/Admin/AdminUserDetailed.dart';

class AdmUserList extends StatefulWidget {
  const AdmUserList({Key? key}) : super(key: key);

  @override
  State<AdmUserList> createState() => _AdmUserListState();
}

class UserList {
  final String name;
  final String role;
  final String imgLink;
  final String userID;
  final String status;

  UserList(
      {required this.name,
      required this.role,
      required this.imgLink,
      required this.userID,
      required this.status});
}

class _AdmUserListState extends State<AdmUserList> {
  late User user;
  late Future<DocumentSnapshot> userData;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<UserList>> getUserData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<UserList> userList = [];
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      UserList updateData = UserList(
        userID: doc.id,
        name: data['username'],
        role: data['userrole'],
        imgLink: data['image_url'],
        status: data['status'],
      );
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Text("Users",
                      style: Theme.of(context).textTheme.headlineLarge),
                ),
                SizedBox(
                  width: 120,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your link here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminInstructorApprovals()),
                      ).then((_) => setState(() {}));
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey),
                    ),
                    child: const Text(
                      "Approvals",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
              FutureBuilder(
                  future: getUserData(),
                  builder: (context, snapshot1) {
                    if (snapshot1.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot1.hasError) {
                      return Center(child: Text('Error: ${snapshot1.error}'));
                    } else {
                      List<UserList> userlist =
                          snapshot1.data as List<UserList>;

                      return Container(
                          height: MediaQuery.of(context).size.height - 170,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: userlist.length,
                              itemBuilder: (context, index) {
                                UserList user = userlist[index];
                                String userName = user.name;
                                String userRole = user.role;
                                String imgLink = user.imgLink;
                                String userStatus = user.status;
                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              color: switch (userStatus) {
                                                'BAN' => Colors.red[400],
                                                'WARN' => Colors.red[200],
                                                _ => const Color(
                                                    0xFFE0F4F5), // default color
                                              },
                                            ),
                                            child: Row(children: [
                                              Container(
                                                width: 70,
                                                height: 70,
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(5, 0, 5, 0),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: const BoxDecoration(
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
                                                        .fromSTEB(10, 0, 5, 0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('$userRole',
                                                        style: const TextStyle(
                                                            fontSize: 30,
                                                            fontFamily:
                                                                'Inter')),
                                                    Text('$userName',
                                                        style: const TextStyle(
                                                            fontSize: 20,
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
                                                        EdgeInsets.all(8.0),
                                                    child: Container(
                                                      width: 75,
                                                      height: 75,
                                                      decoration: BoxDecoration(
                                                        color: const Color
                                                            .fromARGB(
                                                            100, 50, 117, 131),
                                                        shape:
                                                            BoxShape.rectangle,
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
                                                                            AdmUserDetailedPage(
                                                                      userID: user
                                                                          .userID,
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
                  })
            ],
          ),
        ));
  }
}
