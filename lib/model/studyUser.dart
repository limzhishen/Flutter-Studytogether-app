import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mae_part2_studytogether/model/Course.dart';

class StudyUser {
  final String email;
  final String image_url;
  final String phonenumber;
  final String tag1;
  final String tag2;
  final String tag3;
  final String username;
  final String userrole;
  final String password;
  final String status;
  final String uid;

  const StudyUser(
      {required this.email,
      required this.image_url,
      required this.phonenumber,
      required this.tag1,
      required this.tag2,
      required this.tag3,
      required this.username,
      required this.userrole,
      required this.password,
      required this.uid,
      required this.status});
  Future<void> createUser(String location) async {
    return await FirebaseFirestore.instance.collection(location).doc(uid).set({
      'username': username,
      'email': email,
      'image_url': image_url,
      'userrole': userrole,
      'phonenumber': phonenumber,
      'password': password,
      'uid': uid,
      'tag1': tag1,
      'tag2': tag2,
      'tag3': tag3,
      'status': status
    });
  }

  Future<void> updateUser(String location) async {
    return await FirebaseFirestore.instance
        .collection(location)
        .doc(uid)
        .update({
      'username': username,
      'email': email,
      'image_url': image_url,
      'userrole': userrole,
      'phonenumber': phonenumber,
      'password': password,
      'uid': uid,
      'tag1': tag1,
      'tag2': tag2,
      'tag3': tag3,
      'status': status
    });
  }

  Future<void> makeapplication(String friends) async {
    await FirebaseFirestore.instance
        .collection('FriendsApplication')
        .doc(friends)
        .set({uid: friends}, SetOptions(merge: true));
  }

  Future<void> addfriends(String friends) async {
    await FirebaseFirestore.instance
        .collection('Friends')
        .doc(uid)
        .set({friends: friends}, SetOptions(merge: true));
  }

  Future<void> deleteapplication(String friends) async {
    await FirebaseFirestore.instance
        .collection('FriendsApplication')
        .doc(uid)
        .update({friends: FieldValue.delete()});
  }

  Future<DocumentSnapshot> getapplicationcompare() async {
    return await FirebaseFirestore.instance
        .collection('FriendsApplication')
        .doc(uid)
        .get();
  }

  Future<List<Course>> getCourseData() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('enrroledcourse')
        .doc(uid)
        .get();
    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      List<Course> courses = [];
      for (String courseId in userData.keys) {
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

  Future<List<StudyUser>> getapplication() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('FriendsApplication')
        .doc(uid)
        .get();
    List<StudyUser> userList = [];
    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      for (String userid in data.keys) {
        DocumentSnapshot usersnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userid)
            .get();
        StudyUser userdata = changetoUser(usersnapshot);
        userList.add(userdata);
      }
    }
    return userList;
  }
}

StudyUser changetoUser(DocumentSnapshot user) {
  StudyUser newuser = StudyUser(
      email: user['email'],
      image_url: user['image_url'],
      phonenumber: user['phonenumber'],
      tag1: user['tag1'],
      tag2: user['tag2'],
      tag3: user['tag3'],
      username: user['username'],
      userrole: user['userrole'],
      status: user['status'],
      password: user['password'],
      uid: user['uid']);
  return newuser;
}

Future<List<StudyUser>> getallUser() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();
  List<StudyUser> userList = [];
  querySnapshot.docs.forEach((element) {
    ;
    StudyUser user = changetoUser(element);
    userList.add(user);
  });
  return userList;
}

Future<DocumentSnapshot> getUserData(String uid) async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  return documentSnapshot;
}

Future<List<StudyUser>> getFriendsData(String useruid) async {
  DocumentSnapshot documentSnapshot =
      await FirebaseFirestore.instance.collection('Friends').doc(useruid).get();
  List<StudyUser> userList = [];
  if (documentSnapshot.exists) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    for (String userid in data.values) {
      DocumentSnapshot usersnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .get();
      StudyUser userdata = changetoUser(usersnapshot);
      userList.add(userdata);
    }
  }
  return userList;
}
