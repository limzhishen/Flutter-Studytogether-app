import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/screens/Admin/Adminnavigator.dart';
import 'package:mae_part2_studytogether/screens/Instructor/InstructorNavigator.dart';
import 'package:mae_part2_studytogether/screens/Learner/LearnerNavigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';

class Identifypage extends StatefulWidget {
  const Identifypage({super.key});
  @override
  State<Identifypage> createState() => _NavigatorPage();
}

void _showdialog(
    BuildContext context, String title, String content, String button) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              button,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

class _NavigatorPage extends State<Identifypage> {
  late User user;
  late StudyUser userData;
  late int _currentIndex = 2;
  //getdata
  Future<StudyUser> fetchUserData(User user) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!documentSnapshot.exists) {
      FirebaseAuth.instance.signOut();
      _showdialog(context, 'Pending Application',
          'Please wait for your application to be checked and approved.', 'OK');
    }
    userData = changetoUser(documentSnapshot);

    if (userData.status == 'WARN') {
      _showdialog(
          context, 'WARN ACCOUNT', 'You have been WARN. Don\'t HamSap', 'OkOK');
    }
    if (userData.status == 'BAN') {
      FirebaseAuth.instance.signOut();
      _showdialog(context, 'BANNED ACCOUNT', 'You have been BAN.', 'SAD');
    }
    return userData;
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchUserData(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          if (userData.userrole == "Admin") {
            return AdmNavigatorpage();
          } else if (userData.userrole == "Instructor") {
            return IntructorNavigator(
              user: user,
            );
          } else if (userData.userrole == "Learner") {
            return LearnerNavigatorpage(user: user);
          } else {
            return const Scaffold(
              body: Center(
                child: Text('Unknown user type!'),
              ),
            );
          }
        }
      },
    );
  }
}
