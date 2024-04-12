import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mae_part2_studytogether/model/Course.dart';
import 'package:mae_part2_studytogether/widgets/Textinputfied.dart';
import 'package:mae_part2_studytogether/widgets/customAppbar.dart';
import 'package:mae_part2_studytogether/model/Coursetype.dart';
import 'package:mae_part2_studytogether/widgets/tagdropwidget.dart';

class InstructorCoursePage extends StatefulWidget {
  final User user;
  final Course course;
  const InstructorCoursePage(
      {super.key, required this.user, required this.course});

  @override
  State<InstructorCoursePage> createState() => _InstructorCoursePage();
}

class _InstructorCoursePage extends State<InstructorCoursePage> {
  final _form = GlobalKey<FormState>();
  var _coursename = '';
  var _paymentfee = '0';
  var _paymenttype = '';
  var couruid = '';
  var joincourse = 0;
  var _courseDescription = '';
  var imageUrl = '';

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
  void initState() {
    super.initState();
    // Initialize imageUrl with the course's imageUrl
    imageUrl = widget.course.imageUrl;
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

  void _submit(Course course) async {
    final isValid = _form.currentState!.validate();
    if (_paymenttype == null || _paymenttype == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a Payment Type.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
    }
    if (type == null || type == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select a Course Type.'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
    }
    if (!isValid ||
        _paymenttype == null ||
        _paymenttype == '' ||
        type == null ||
        type == '') {
      return;
    }
    _form.currentState!.save();
    {
      setState(() {
        _isAuthenticating = true;
      });

      await FirebaseFirestore.instance
          .collection('course')
          .doc(course.courseuid)
          .update({
        'imageUrl': imageUrl,
        'name': _coursename,
        'CourseFee': _paymentfee,
        'CourseDescription': _courseDescription,
        'joincourse': course.joincourse,
        'type': type,
        'paymenttype': _paymenttype,
        'teacheruid': widget.user.uid,
        'courseuid': course.courseuid,
        'chatRoomID': course.chatroomid,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Course course = widget.course;
    type = course.type;

    _paymenttype = course.paymenttype;
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
                "Editing Course ",
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
                          const SizedBox(
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
                              child: const Text(
                                "Refresh",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ))
                        ],
                      ),
                      TextInputField(
                        labelText: "Coursename",
                        hintText: "Coursename...",
                        initialValue: course.name,
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
                        initialValue: course.CourseDescription,
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
                        initialValue: course.CourseFee,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null;
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          if (value == null) {
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
                          tagvalue: course.type,
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
                          tagvalue: course.paymenttype,
                          item: payType,
                          isedit: false,
                          onChanged: _updatepaymenttype,
                          width: 80,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          _submit(course);
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Course Editing'),
                              content: const Text(
                                  "Your course has been successfully Editing."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "Ok",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          );
                          Navigator.pop(context, true);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 246, 242, 212)),
                          elevation: MaterialStateProperty.all<double>(4),
                        ),
                        child: Text("Edit Course",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onBackground)),
                      )
                    ]),
              ))
        ]),
      ),
    );
  }
}
