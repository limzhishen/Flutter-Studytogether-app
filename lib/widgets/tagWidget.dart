import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  final String text;

  const TagWidget({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        splashColor: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'Inter',
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
