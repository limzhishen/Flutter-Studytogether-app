import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  bool logout;
  CustomAppBar({this.logout = false});
  @override
  Size get preferredSize => Size.fromHeight(45);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF0ABAB5),
      title: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/studyTogetherLogo.png',
            width: 230,
            height: 35,
            fit: BoxFit.fitWidth,
            alignment: Alignment(0, 1),
          ),
        ),
      ),
      actions: logout
          ? [
              Align(
                alignment: AlignmentDirectional(0, 0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                  child: IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    icon: Icon(
                      Icons.logout,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]
          : [],
      centerTitle: false,
      elevation: 1.0,
    );
  }
}
