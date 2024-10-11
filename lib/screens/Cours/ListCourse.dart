import 'package:formagil_app_admin/models/Course.dart';
import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/screens/Former/TileFormer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:provider/provider.dart';

import 'CourseTile.dart';

class CourseList extends StatefulWidget {
  @override
  _CourseListState createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  @override
  Widget build(BuildContext context) {
    final cours = Provider.of<List<Course>>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
        itemCount: cours?.length ?? 0,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: width / (height / 1.5)
        ),
        itemBuilder: (context, int index) {
          return CourseTile(course: cours[index]);
        });
  }
}
