import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:mae_part2_studytogether/model/Course.dart';
import 'package:mae_part2_studytogether/screens/Learner/LearnerCoursePage.dart';

class CourseCarousel extends StatelessWidget {
  final List<Course> courses;
  final User user;
  const CourseCarousel({
    required this.courses,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: courses.length,
      itemBuilder: (context, index, realIndex) {
        Course course = courses[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => LearnerCoursePage(
                          course: course,
                          isenrolled: false,
                          user: user,
                        )));
          },
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                course.imageUrl,
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
      options: CarouselOptions(
        initialPage: 1,
        viewportFraction: 0.5,
        disableCenter: true,
        enlargeCenterPage: true,
        enlargeFactor: 0.25,
        enableInfiniteScroll: false,
        scrollDirection: Axis.horizontal,
        autoPlay: false,

        //onPageChanged: (index, _) => _model.carouselCurrentIndex = index,
      ),
    );
  }
}
