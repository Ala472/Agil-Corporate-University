import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/services/sidebar.dart';

import 'LoginScreen.dart';

DatabaseService _services = DatabaseService();
class AdminUser extends StatelessWidget {
  static const String id = 'admin-user';

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff221e1f),
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.logout, color: Color(0xffffde00),),
            label: Text('Sign Out', style: TextStyle(color: Color(0xffffde00)),),
            onPressed: () async {
              await _services.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.id, (Route<dynamic> route) => false);
            },
          ),
        ],
        title: const Text('Agil Corporate University', style: TextStyle(color: Colors.white),),),
      sideBar: _sideBar.sideBarMenus(context, AdminUser.id),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 100,
                  backgroundImage: Image.asset('assets/images/logoavatar.png').image,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'SNDP AGIL',
                  textScaleFactor: 4,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'La Société Nationale de Distribution des Pétroles AGIL S.A.',
                  style: Theme.of(context).textTheme.caption,
                  textScaleFactor: 2,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Adresse: Av. Mohamed Ali Akid Cité Olympique -1003 El Khadra - BP 762 - Tunis - Tunisie Tél.: 00216 71 707\n 222 / 71 703 222 Fax: 00216 71 704 333 Email : boc@agil.com.tn Site web : www.agil.com.tn/',
                  style: Theme.of(context).textTheme.bodyText1,
                  textScaleFactor: 1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
