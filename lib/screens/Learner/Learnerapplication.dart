import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/widgets/ApplicationBox.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';

class LeannerApplication extends StatefulWidget {
  StudyUser user;
  final VoidCallback? applicationFriends;
  LeannerApplication(
      {super.key, required this.user, required this.applicationFriends});

  @override
  State<LeannerApplication> createState() => _LeannerApplicationState();
}

class _LeannerApplicationState extends State<LeannerApplication> {
  void _refreshPage() {
    setState(() {});

    widget.applicationFriends!();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(),
      body: FutureBuilder(
          future: widget.user.getapplication(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<StudyUser> applicationlist =
                  snapshot.data as List<StudyUser>;
              applicationlist.removeWhere((tempuser) {
                return widget.user.uid == tempuser.uid;
              });
              return SingleChildScrollView(
                child: Column(
                  children: [
                    if (applicationlist.isEmpty)
                      Container(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0, 150, 0, 150),
                        child: const Center(
                          child: Text('No Friends Application Yet',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 24)),
                        ),
                      ),
                    if (applicationlist.isNotEmpty)
                      ApplicationBox(
                        applicationlist: applicationlist,
                        currentuser: widget.user,
                        applicationFriends: _refreshPage,
                      )
                  ],
                ),
              );
            }
          }),
    );
  }
}
