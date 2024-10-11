import 'package:formagil_app_admin/models/survey.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SurveyTile.dart';

class SurveyList extends StatefulWidget {
  @override
  _SurveyListState createState() => _SurveyListState();
}

class _SurveyListState extends State<SurveyList> {
  @override
  Widget build(BuildContext context) {
    final survey = Provider.of<List<Survey>>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
        itemCount: survey?.length ?? 0,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.87
        ),
        itemBuilder: (context, int index) {
          return SurveyTile(survey: survey[index]);
        });
  }
}

