import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/screens/Admin/AdminDashboard.dart';
import 'package:mae_part2_studytogether/screens/Admin/AdminReports.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mae_part2_studytogether/screens/Admin/AdminUserList.dart';
import 'package:mae_part2_studytogether/screens/Admin/AdminCourses.dart';
import 'package:mae_part2_studytogether/screens/Admin/AdminSettings.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';

class AdmNavigatorpage extends StatefulWidget {
  const AdmNavigatorpage({super.key});
  @override
  State<AdmNavigatorpage> createState() => _AdmNavigatorpage();
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
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

class _AdmNavigatorpage extends State<AdmNavigatorpage> {
  late User user;
  late StudyUser userData;
  late int _currentIndex = 2;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    user = FirebaseAuth.instance.currentUser!;
    fetchUserData(user);
  }

  void fetchUserData(User user) async {
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar( title: Text("Hello"), ),
      //resizeToAvoidBottomInset: false,
      body: SizedBox.expand(
        // ignore: unnecessary_null_comparison
        child: user != null
            ? PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                  const AdmUserList(),
                  const AdmReportsPage(),
                  const AdmDashBoardpage(),
                  const AdminCourses(),
                  AdminSettings(user: user),
                ],
              )
            : const CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: const Text("Users"), icon: const Icon(Icons.people)),
          BottomNavyBarItem(
              title: const Text("Reports"), icon: const Icon(Icons.report)),
          BottomNavyBarItem(
              title: const Text("Dashboard"), icon: const Icon(Icons.apps)),
          BottomNavyBarItem(
              title: const Text("Course"), icon: const Icon(Icons.book_online)),
          BottomNavyBarItem(
              title: const Text("Settings"), icon: const Icon(Icons.settings)),
        ],
      ),
    );
  }
}
