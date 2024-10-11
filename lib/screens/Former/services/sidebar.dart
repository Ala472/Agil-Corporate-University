import 'dart:html';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/screens/Former/screens/ProfilScreen.dart';
import 'package:formagil_app_admin/screens/Former/screens/ManageCourse.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/services/firebase_services.dart';
import 'package:provider/provider.dart';


class SideBarWidgetFormer extends ChangeNotifier {
  final String uid;
  SideBarWidgetFormer({this.uid});

  sideBarMenus(context, selectedRoute) {
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
          title: 'Gestion des Cours',
          route: ManageCourse.id,
          icon: CupertinoIcons.doc_on_clipboard_fill,
        ),
        MenuItem(
          title: 'Mon Profil',
          route: ProfilScreen.id,
          icon: CupertinoIcons.profile_circled,
        ),
      ],
      selectedRoute: selectedRoute,
      onSelected: (item) {
        window.history.pushState(null, null, '/#/${item.route}');
        Navigator.of(context).pushNamed(item.route);
      },
      header: StreamBuilder<Former>(
        stream: DatabaseService(uid: uid)?.former,
        builder: (context, snapshot) {
          Former former = snapshot?.data;
          if(snapshot.hasData) {
            return Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[200],
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.grey[200]),
                margin: EdgeInsets.only(bottom: 0.0),
                accountName: new Container(
                    child: Text(
                      '${former.nom} ${former.prenom}',
                      style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
                    )),
                accountEmail: new Container(
                    child: Text(
                      '${former.email}',
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
            );
          } else {
            return CircularProgressIndicator();
          }
        }
      ),

    );
  }
}