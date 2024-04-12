import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/screens/Learner/LearnerFriend.dart';
import 'package:mae_part2_studytogether/screens/Learner/Learnersettings.dart';
import 'package:mae_part2_studytogether/screens/Learner/LearnerDashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mae_part2_studytogether/screens/Learner/LearnerJoincourse.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/screens/Learner/LearnerChat.dart';

class LearnerNavigatorpage extends StatefulWidget {
  final User user;
  const LearnerNavigatorpage({super.key, required this.user});
  @override
  State<LearnerNavigatorpage> createState() => _NavigatorPage();
}

class _NavigatorPage extends State<LearnerNavigatorpage> {
  late int _currentIndex = 2;
  late PageController _pageController;
  //getdata
  late StudyUser userData;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    ;
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
        child: user != null
            ? PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: [
                    LearnerFriend(user: user),
                    LearnerChat(user: user),
                    LearnerDashBoardpage(user: user),
                    LearnerJoinCourse(user: user),
                    LearnerSettings(
                      user: user,
                    ),
                  ])
            : CircularProgressIndicator(),
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
