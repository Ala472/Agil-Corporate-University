import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:formagil_app_admin/screens/AdminUser.dart';
import 'package:formagil_app_admin/screens/CategoryScreen.dart';
import 'package:formagil_app_admin/screens/HomeScreen.dart';
import 'package:formagil_app_admin/screens/LearnerScreen.dart';
import 'package:formagil_app_admin/screens/LoginScreen.dart';
import 'package:formagil_app_admin/screens/ManageFormer.dart';
import 'package:formagil_app_admin/screens/ProductScreen.dart';
import 'package:formagil_app_admin/screens/SurveyScreen.dart';

class SideBarWidget{

  sideBarMenus(context, selectedRoute){
    return SideBar(
      width: 250,
      borderColor: Colors.grey[200],
      activeBackgroundColor: Color(0xff221e1f),
      activeIconColor: Color(0xffffde00),
      activeTextStyle: TextStyle(color: Color(0xffffde00), fontWeight: FontWeight.w600),
      iconColor: Color(0xff221e1f),
      textStyle: TextStyle(color: Color(0xff221e1f), fontWeight: FontWeight.w600),
      backgroundColor: Colors.grey[200],
      items: const [

        MenuItem(
          title: 'Gestion des Formateurs',
          route: FormerScreen.id,
          icon: CupertinoIcons.person,
        ),
        MenuItem(
          title: 'Gestion des Modules',
          route: CategoryScreen.id,
          icon: Icons.collections_bookmark_outlined,
        ),
        MenuItem(
          title: 'Liste des Apprenants',
          route: LearnerScreen.id,
          icon: CupertinoIcons.doc_person,
        ),
        MenuItem(
          title: 'Gestion des Sondages',
          route: SurveyScreen.id,
          icon: Icons.assistant_photo_outlined,
        ),
        MenuItem(
          title: 'Gestion des Produits',
          route: ProductScreen.id,
          icon: CupertinoIcons.cube_box,
        ),
        MenuItem(
          title: 'Administrateur',
          route: AdminUser.id,
          icon: CupertinoIcons.person_alt_circle,
        ),
      ],
      selectedRoute: selectedRoute,
      onSelected: (item) {
        window.history.pushState(null, null, '/#/${item.route}');
        Navigator.of(context).pushNamed(item.route);
      },
      header: Container(
        height: 150,
        width: double.infinity,
        color: Colors.grey[200],
        child: UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.grey[200]),
          margin: EdgeInsets.only(bottom: 0.0),
          accountName: new Container(
              child: Text(
                'SNDP Agil',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
              )),
          accountEmail: new Container(
              child: Text(
                'ala122@gmail.com',
                style: TextStyle(color: Colors.black),
              )),
          currentAccountPicture: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/logoavatar.png'),)),
          ),
          // currentAccountPicture: new CircleAvatar(
          //   radius: 10.0,
          //   backgroundColor: const Color(0xFF778899),
          //   backgroundImage: new AssetImage('assets/images/logoavatar.png'),
          // ),
          //Callback Events
        ),
      ),

    );
  }
}