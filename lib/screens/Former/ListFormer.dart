import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/screens/Former/TileFormer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:provider/provider.dart';

class FormerList extends StatefulWidget {
  @override
  _FormerListState createState() => _FormerListState();
}

class _FormerListState extends State<FormerList> {
  @override
  Widget build(BuildContext context) {
    final former = Provider.of<List<Former>>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
          itemCount: former?.length ?? 0,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: width<1536 ? 3 : 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: width / (height / 2)
          ),
          itemBuilder: (context, int index) {
            return FormerTile(former: former[index]);
          });
  }
}

