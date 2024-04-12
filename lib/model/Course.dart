import 'package:cloud_firestore/cloud_firestore.dart';

class Course {
  final String imageUrl;
  final String name;
  final String CourseFee;
  final String CourseDescription;
  final String type;
  final String joincourse;
  final String teacheruid;
  final String paymenttype;
  final String courseuid;
  final String chatroomid;

  Course(
      {required this.imageUrl,
      required this.name,
      required this.CourseFee,
      required this.CourseDescription,
      required this.type,
      required this.joincourse,
      required this.teacheruid,
      required this.paymenttype,
      required this.courseuid,
      required this.chatroomid});
}

Future<List<Course>> getCourseAllData() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('course').get();
  List<Course> courses = [];
  querySnapshot.docs.forEach((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Course course = Course(
        imageUrl: data['imageUrl'],
        name: data['name'],
        CourseFee: data['CourseFee'],
        CourseDescription: data['CourseDescription'],
        joincourse: data['joincourse'],
        type: data['type'],
        paymenttype: data['paymenttype'],
        teacheruid: data['teacheruid'],
        courseuid: data['courseuid'],
        chatroomid: data['chatRoomID']);

    courses.add(course);
  });

  return courses;
}

Course changeTocouse(DocumentSnapshot data) {
  Course newcourse = Course(
      imageUrl: data['imageUrl'],
      name: data['name'],
      CourseFee: data['CourseFee'],
      CourseDescription: data['CourseDescription'],
      joincourse: data['joincourse'],
      type: data['type']!,
      paymenttype: data['paymenttype'],
      teacheruid: data['teacheruid'],
      courseuid: data['courseuid'],
      chatroomid: data['chatRoomID']);
  return newcourse;
}

Future<List<Course>> getPersonalCourseData(String uid) async {
  DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
      .collection('courseCreate')
      .doc(uid)
      .get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> coursedata =
        documentSnapshot.data() as Map<String, dynamic>;
    List<Course> courses = [];
    for (String courseId in coursedata.keys) {
      DocumentSnapshot courseSnapshot = await FirebaseFirestore.instance
          .collection('course')
          .doc(courseId)
          .get();

      if (courseSnapshot.exists) {
        Course course = changeTocouse(courseSnapshot);

        courses.add(course);
      }
    }
    return courses;
  } else {
    return [];
  }
}
