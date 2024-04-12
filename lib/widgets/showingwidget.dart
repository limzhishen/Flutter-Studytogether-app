import 'package:flutter/material.dart';

class ShowingWidget extends StatelessWidget {
  final String name;
  final String namevalue;
  final Icon icon;
  const ShowingWidget(
      {super.key,
      required this.name,
      required this.namevalue,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(name),
          subtitle: Text(namevalue),
          leading: icon,
        ),
      ),
    );
  }
}
