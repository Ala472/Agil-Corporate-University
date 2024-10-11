import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/models/product.dart';
import 'package:formagil_app_admin/screens/Former/TileFormer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:provider/provider.dart';

import 'TileProduct.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<List<Product>>(context);
    double height = MediaQuery.of(context).size.height / 3;
    double width = MediaQuery.of(context).size.width / 1.25;

    return GridView.builder(
                itemCount: product?.length ?? 0,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1
                ),
                itemBuilder: (context, int index) {
                  return TileProduct(product: product[index]);
                }
    );
  }
}

