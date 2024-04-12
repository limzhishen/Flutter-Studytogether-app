import 'dart:io';

import 'package:flutter/material.dart';

class tagdropWidget extends StatefulWidget {
  final String tagname;
  String tagvalue;
  final List<String> item;
  final bool isedit;
  final ValueChanged<String?> onChanged;
  tagdropWidget(
      {required this.tagname,
      required this.tagvalue,
      required this.item,
      required this.isedit,
      required this.onChanged});

  @override
  State<tagdropWidget> createState() => _tagboxWidgetState();
}

class _tagboxWidgetState extends State<tagdropWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            widget.tagname,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
                  value: widget.tagvalue.isEmpty || widget.tagvalue == ''
                      ? null
                      : widget.tagvalue,
                  items: widget.item
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: widget.isedit
                      ? null
                      : (val) {
                          setState(() {
                            widget.tagvalue = val!;
                          });
                          widget.onChanged(val);
                        },
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  elevation: 2,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class tagdropWidget2 extends StatefulWidget {
  final String tagname;
  String tagvalue;
  final List<String> item;
  final bool isedit;
  final ValueChanged<String?> onChanged;
  final double width;
  tagdropWidget2(
      {required this.tagname,
      required this.tagvalue,
      required this.item,
      required this.isedit,
      required this.onChanged,
      required this.width});

  @override
  State<tagdropWidget2> createState() => _tagboxWidgetState2();
}

class _tagboxWidgetState2 extends State<tagdropWidget2> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            widget.tagname,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: widget.width,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
                  value: widget.tagvalue.isEmpty || widget.tagvalue == ''
                      ? null
                      : widget.tagvalue,
                  items: widget.item
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: widget.isedit
                      ? null
                      : (val) {
                          setState(() {
                            widget.tagvalue = val!;
                          });
                          widget.onChanged(val);
                        },
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  elevation: 2,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class tagdropWidget3 extends StatefulWidget {
  String tagvalue;
  final List<String> item;
  final bool isedit;
  final ValueChanged<String?> onChanged;
  tagdropWidget3(
      {required this.tagvalue,
      required this.item,
      required this.isedit,
      required this.onChanged});

  @override
  State<tagdropWidget3> createState() => _tagboxWidgetState3();
}

class _tagboxWidgetState3 extends State<tagdropWidget3> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: 120,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.blue, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
                  value: widget.tagvalue.isEmpty || widget.tagvalue == ''
                      ? null
                      : widget.tagvalue,
                  items: widget.item
                      .map((e) => DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                  onChanged: widget.isedit
                      ? null
                      : (val) {
                          setState(() {
                            widget.tagvalue = val!;
                          });
                          widget.onChanged(val);
                        },
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.blue),
                  elevation: 2,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
