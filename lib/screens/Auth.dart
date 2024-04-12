import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mae_part2_studytogether/model/studyUser.dart';
import 'package:mae_part2_studytogether/widgets/user_image_picker.dart';
import 'package:mae_part2_studytogether/widgets/Textinputfied.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  final VoidCallback? login;
  AuthScreen({super.key, required this.login});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _phonenumber = '';
  var _userRole = '';
  var _isuserRole = true;
  File? _selectedImage;
  var _isAuthenticating = false;
  late TextEditingController _passwordController;
  bool _passwordVisibility = false;
  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (_selectedImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select an image.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
    }
    if ((!isValid || !_isLogin && _selectedImage == null)) {
      return;
    }
    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isuserRole) {
        _userRole = 'Learner';
      } else {
        _userRole = 'Instructor';
      }

      if (_isLogin) {
        final userCredential = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredential = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');

        await storageRef.putFile(_selectedImage!);
        widget.login!();
        final imageUrl = await storageRef.getDownloadURL();
        StudyUser createuser = StudyUser(
            email: _enteredEmail,
            image_url: imageUrl,
            phonenumber: _phonenumber,
            tag1: '',
            tag2: '',
            tag3: '',
            username: _enteredUsername,
            userrole: _userRole,
            password: _enteredPassword,
            uid: userCredential.user!.uid,
            status: 'OK');
        if (_isuserRole) {
          //learner
          await createuser.createUser('users');
        } else {
          //instructor
          createuser.createUser('applications');
        }

        FirebaseAuth.instance.signOut();
        _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      }
      setState(() {
        _isAuthenticating = false;
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authntication failed.')));
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    // _passwordVisibility ??= TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * 1,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F4F5),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Color(0x33000000),
                        offset: Offset(0, 2),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_isLogin)
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 56, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 150, 0, 100),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        'assets/images/studyTogetherLogo.png',
                                        width: 325,
                                        height: 65,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (!_isLogin)
                            Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 56, 0, 0),
                                child: Column(children: [
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 30,
                                          bottom: 20,
                                          left: 20,
                                          right: 20),
                                      width: 200,
                                      child: Image.asset(
                                          'assets/images/studyTogetherLogo.png'))
                                ])),
                          Form(
                              key: _form,
                              child: Column(children: [
                                if (!_isLogin)
                                  UserImagePicker(
                                    onPickImage: (pickedImage) {
                                      _selectedImage = pickedImage;
                                    },
                                  ),
                                if (!_isLogin)
                                  TextInputField(
                                    labelText: "Username",
                                    hintText: 'Username...',
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
                                  ),
                                TextInputField(
                                  labelText: 'Email',
                                  hintText: 'xxx@mail.com',
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
                                ),
                                TextInputField(
                                  //controller: _passwordController,
                                  labelText: 'Password',
                                  hintText: 'Password...',
                                  obscureText: !_passwordVisibility,
                                  togglePasswordVisibility: () => setState(
                                    () => _passwordVisibility =
                                        !_passwordVisibility,
                                  ),
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
                                ),
                                if (!_isLogin)
                                  TextInputField(
                                    labelText: 'PhoneNumber',
                                    hintText: '01.....',
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
                                  ),
                                if (_isLogin)
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 190, 0),
                                    child: Material(
                                      elevation: 0,
                                      color: Colors.transparent,
                                      child: TextButton(
                                        onPressed: () {
                                          print(
                                              'Button-ForgotPassword pressed ...');
                                        },
                                        style: ButtonStyle(
                                          overlayColor: MaterialStateProperty
                                              .resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                              if (states.contains(
                                                  MaterialState.hovered)) {
                                                return Colors.transparent;
                                              }
                                              //have problem
                                              return Colors.white;
                                            },
                                          ),
                                          padding: MaterialStateProperty.all<
                                              EdgeInsetsGeometry>(
                                            EdgeInsets.zero,
                                          ),
                                          side: MaterialStateProperty.all<
                                              BorderSide>(
                                            const BorderSide(
                                              color: Colors.transparent,
                                              width: 1,
                                            ),
                                          ),
                                          shape: MaterialStateProperty.all<
                                              OutlinedBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSecondary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (!_isLogin)
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 4, 0),
                                    child: !_isAuthenticating
                                        ? ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                _isuserRole = !_isuserRole;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: _isuserRole
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                              fixedSize: Size(200, 50),
                                            ),
                                            child: Text(
                                              _isuserRole
                                                  ? 'Learner'
                                                  : 'Instructor',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 4, 0),
                                  child: !_isAuthenticating
                                      ? ElevatedButton(
                                          onPressed: _submit,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                          child: Text(
                                            _isLogin ? 'Login' : 'Signup',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 10, 4, 0),
                                  child: !_isAuthenticating
                                      ? ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _isLogin = !_isLogin;
                                            });
                                            widget.login!();
                                          },
                                          child: Text(
                                            _isLogin
                                                ? 'Create an account'
                                                : 'I already have an account',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                          ),
                                        )
                                      : SizedBox(),
                                ),
                              ]))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
