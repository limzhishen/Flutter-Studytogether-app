import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/screens/Instructor/InstructorChat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mae_part2_studytogether/screens/Instructor/InstructorDashboard.dart';
import 'package:mae_part2_studytogether/screens/Instructor/InstuctorCourse.dart';
import 'package:mae_part2_studytogether/screens/Instructor/InstuctorSettings.dart';

import 'package:mae_part2_studytogether/screens/Learner/LearnerFriend.dart';

class IntructorNavigator extends StatefulWidget {
  final User user;
  const IntructorNavigator({super.key, required this.user});
  @override
  State<IntructorNavigator> createState() => _NavigatorPage();
}

class _NavigatorPage extends State<IntructorNavigator> {
  late int _currentIndex = 2;
  late PageController _pageController;
  //getdata

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
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
                    LearnerFriend(
                      user: user,
                    ),
                    InstructorChat(user: user),
                    InstructorDashboard(
                      user: user,
                    ),
                    InstuctorCourse(user: user),
                    InstructorSettings(user: user),
                  ])
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
              title: const Text("Friends"), icon: const Icon(Icons.people)),
          BottomNavyBarItem(
              title: const Text("Chat"), icon: const Icon(Icons.chat_bubble)),
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
