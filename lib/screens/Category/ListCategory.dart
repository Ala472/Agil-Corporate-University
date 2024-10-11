import 'package:formagil_app_admin/models/category.dart';
import 'package:formagil_app_admin/screens/Category/TileCategory.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCategory extends StatefulWidget {
  @override
  _ListCategoryState createState() => _ListCategoryState();
}

class _ListCategoryState extends State<ListCategory> {
  @override
  Widget build(BuildContext context) {

    final category = Provider.of<List<Category>>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GridView.builder(
        itemCount: category?.length ?? 0,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: width / (height),
        ),
        itemBuilder: (context, int index) {
          return CategoryTile(category: category[index],);
        });
  }
}
