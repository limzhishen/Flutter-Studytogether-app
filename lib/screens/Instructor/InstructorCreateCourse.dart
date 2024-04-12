import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/widgets/Textinputfied.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/model/Coursetype.dart';
import 'package:mae_part2_studytogether/widgets/tagdropwidget.dart';

class InstructorCreateCourse extends StatefulWidget {
  final User user;
  const InstructorCreateCourse({super.key, required this.user});

  @override
  State<InstructorCreateCourse> createState() => _InstructorCreateCourseState();
}

class _InstructorCreateCourseState extends State<InstructorCreateCourse> {
  final _form = GlobalKey<FormState>();
  var _coursename = '';
  var _paymentfee = '0';
  var _paymenttype = '';
  var couruid = '';
  var joincourse = 0;
  var _courseDescription = '';
  var imageUrl = 'https://content.hostgator.com/img/weebly_image_sample.png';

  var type = '';
  var _isAuthenticating = false;
  final _imageUrlController = TextEditingController();
  void _refreshImage() {
    final newImageUrl = _imageUrlController.text.trim();

    if (newImageUrl.isNotEmpty) {
      setState(() {
        imageUrl = newImageUrl;
      });
    }
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updatetype(String? value) {
    if (value != '') {
      type = value!;
    }
  }

  void _updatepaymenttype(String? value) {
    if (value != '') {
      _paymenttype = value!;
    }
  }

  Future<bool> _submit() async {
    final isValid = _form.currentState!.validate();
    if (_paymenttype == null || _paymenttype == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a Payment Type.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
    if (type == null || type == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a Course Type.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
      return false;
    }
    if (!isValid ||
        _paymenttype == null ||
        _paymenttype == '' ||
        type == null ||
        type == '') {
      return false;
    }
    _form.currentState!.save();
    {
      setState(() {
        _isAuthenticating = true;
      });
      DocumentReference documentReference =
          await FirebaseFirestore.instance.collection('course').add({
        'imageUrl': imageUrl,
        'name': _coursename,
        'CourseFee': _paymentfee.toString(),
        'CourseDescription': _courseDescription,
        'joincourse': joincourse.toString(),
        'type': type,
        'paymenttype': _paymenttype,
        'teacheruid': widget.user.uid,
        'courseuid': '',
        'chatRoomID': '',
      });
      String courseuid = documentReference.id;
      await FirebaseFirestore.instance
          .collection('course')
          .doc(courseuid)
          .update({'courseuid': courseuid});
      await FirebaseFirestore.instance
          .collection('courseCreate')
          .doc(widget.user.uid)
          .set({courseuid: courseuid}, SetOptions(merge: true));
      List<dynamic> insChatRoomsID;

      DocumentReference newDocRef = await FirebaseFirestore.instance
          .collection('chatContent')
          .add({
        'chatRoomName': "GC:$courseuid",
        'latest_text': 'New Course Group Chat'
      });
      String newChatRoomID = newDocRef.id;
      DocumentSnapshot userRoom = await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(widget.user.uid)
          .get();

      if (userRoom.exists == false) {
        await FirebaseFirestore.instance
            .collection('chatRooms')
            .doc(widget.user.uid)
            .set({
          'chatRoomsID': [],
        });
      }

      if (userRoom.exists) {
        insChatRoomsID = userRoom['chatRoomsID'];
      } else {
        insChatRoomsID = [];
      }
      insChatRoomsID.add(newChatRoomID);
      print("Instructor rooms: $insChatRoomsID");

      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(widget.user.uid)
          .update({
        'chatRoomsID': insChatRoomsID,
      });
      await FirebaseFirestore.instance
          .collection('course')
          .doc(courseuid)
          .set({'chatRoomID': newChatRoomID}, SetOptions(merge: true));
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Creating New Course ",
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
          const Divider(
            color: Colors.black,
            thickness: 2,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
            child: Container(
              width: 100,
              height: 100,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  //shape: BoxShape.circle,
                  border: Border.all(color: Colors.green)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Form(
              key: _form,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextInputField2(
                              labelText: 'ImageURL',
                              hintText: "http://",
                              controller: _imageUrlController,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: _refreshImage,
                              style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all<Size>(
                                  Size(100, 30),
                                ),
                                elevation: MaterialStateProperty.all<double>(4),
                              ),
                              child: Text(
                                "Refresh",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ))
                        ],
                      ),
                      TextInputField(
                        labelText: "Coursename",
                        hintText: "Coursename...",
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.trim().length <= 3) {
                            return 'Please enter at least 4 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _coursename = value!;
                        },
                      ),
                      TextInputField(
                        labelText: "CourseDescription",
                        hintText: "CourseDescription...",
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              value.trim().length <= 3) {
                            return 'Please enter at least 4 characters.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _courseDescription = value!;
                        },
                      ),
                      TextInputField(
                        labelText: "CourseFee",
                        hintText: "If no put is free...",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          if (double.tryParse(value!) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value == null || value.trim() == null) {
                            _paymentfee = '0';
                          } else {
                            _paymentfee = value!;
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: tagdropWidget2(
                          tagname: 'Course Type',
                          tagvalue: '',
                          item: courseTypes,
                          isedit: false,
                          onChanged: _updatetype,
                          width: 150,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: tagdropWidget2(
                          tagname: 'Payment Type',
                          tagvalue: '',
                          item: payType,
                          isedit: false,
                          onChanged: _updatepaymenttype,
                          width: 80,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final success = await _submit();
                          if (success) {
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Course Created'),
                                content: Text(
                                    "Your course has been successfully created."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            Navigator.pop(context, true);
                          }
                        },
                        child: Text("Create Course",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 246, 242, 212)),
                          elevation: MaterialStateProperty.all<double>(4),
                        ),
                      )
                    ]),
              ))
        ]),
      ),
    );
  }
}
