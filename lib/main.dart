import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'package:mae_part2_studytogether/screens/Auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mae_part2_studytogether/screens/Identify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // For checking User login status if login signout
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    await FirebaseAuth.instance.signOut();
  }
  //fakelogin();

  // FirebaseAuth.instance
  //     .signInWithEmailAndPassword(email: '123@mail.com', password: '123456');

  runApp(const MyApp());
}

bool login = true;
void changestatus() {
  login = !login;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyTogether',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE0F4F5),
          onPrimary: Colors.white,
          secondary: Color(0xFF0ABAB5),
          onSecondary: Colors.black,
        ),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              //return const SplashScreen();
            }
            if (snapshot.hasData) {
              if (login) return Identifypage();
            }

            return AuthScreen(
              login: changestatus,
            );
          }),
    );
  }
}
