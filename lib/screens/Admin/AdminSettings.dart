import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/widgets/Textinputfied.dart';
import 'package:mae_part2_studytogether/widgets/Textpasswordfield.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminSettings extends StatefulWidget {
  final User user;

  AdminSettings({Key? key, required this.user}) : super(key: key);

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _phonenumber = '';
  var _tag1 = '';
  var _tag2 = '';
  var _tag3 = '';
  bool _isAuthenticating = false;
  bool _onread = true;
  late TextEditingController _passwordController;
  bool _passwordVisibility = false;
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _updatetag1(String? value) {
    if (value != '') {
      _tag1 = value!;
    }
  }

  void _updatetag2(String? value) {
    if (value != '') {
      _tag2 = value!;
    }
  }

  void _updatetag3(String? value) {
    if (value != '') {
      _tag3 = value!;
    }
  }

  void _submit(StudyUser biguser) async {
    final isValid = _form.currentState!.validate();
    if ((!isValid)) {
      return;
    }
    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({
        'username': _enteredUsername,
        'email': _enteredEmail,
        'password': _enteredPassword,
        'phonenumber': _phonenumber,
        'tag1': _tag1,
        'tag2': _tag2,
        'tag3': _tag3,
        'status': biguser.status,
      });
      if (_enteredPassword != biguser.password)
        await FirebaseAuth.instance.currentUser!
            .updatePassword(_enteredPassword);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authntication failed.')));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: CustomAppBar(
        logout: true,
      ),
      body: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            StudyUser userData =
                changetoUser(snapshot.data as DocumentSnapshot);

            return SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Text(
                          'Settings',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        child: Container(
                          width: 100,
                          height: 100,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            userData.image_url,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextInputField(
                                labelText: "Username",
                                hintText: 'Username...',
                                initialValue: userData.username,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      value.trim().length <= 3) {
                                    return 'Please enter at least 4 characters.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredUsername = value!;
                                },
                                readonly: _onread,
                              ),
                              TextInputField(
                                labelText: 'Email',
                                hintText: 'xxx@mail.com',
                                initialValue: userData.email,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().isEmpty ||
                                      !value.contains('@')) {
                                    return 'Please enter a valid email address.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredEmail = value!;
                                },
                                readonly: _onread,
                              ),
                              TextPasswordField(
                                initialValue: userData.password,
                                labelText: 'Password',
                                hintText: 'Password...',
                                //obscureText: !_passwordVisibility,
                                isPassword: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length < 6) {
                                    return 'Password must be at least 6 characters long.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _enteredPassword = value!;
                                },
                                readonly: _onread,
                              ),
                              TextInputField(
                                labelText: 'PhoneNumber',
                                hintText: '01.....',
                                initialValue: userData.phonenumber,
                                validator: (value) {
                                  final RegExp phoneRegex =
                                      RegExp(r'^\+?0\d{9,10}$');
                                  if (value == null ||
                                      value.isEmpty ||
                                      !phoneRegex.hasMatch(value)) {
                                    return 'Please enter a valid Malaysian phone number.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _phonenumber = value!;
                                },
                                readonly: _onread,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.tightFor(
                              width: 200, height: 50),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _onread = !_onread;
                                if (_onread) {
                                  _submit(userData);
                                }
                              });
                            },
                            child: Text(
                              _onread ? 'Edit Profile' : 'Save Profile',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            );
          }
        },
      ),
    );
  }
}
