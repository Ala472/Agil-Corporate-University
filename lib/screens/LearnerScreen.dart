import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:formagil_app_admin/models/learner.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/services/sidebar.dart';
import 'package:provider/provider.dart';

import 'Learner/DataTables.dart';
import 'LoginScreen.dart';

class LearnerScreen extends StatefulWidget {
  static const String id = 'learner-screen';
  final Learner learner;
  LearnerScreen({this.learner});
  @override
  _LearnerScreenState createState() => _LearnerScreenState();
}

class _LearnerScreenState extends State<LearnerScreen> {


  DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {

    SideBarWidget _sideBar = SideBarWidget();
    var learners = Provider.of<DatabaseService>(context);
    List<Learner> learn;
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
              await db.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.id, (Route<dynamic> route) => false);
            },
          ),
        ],
        title: const Text('Agil Corporate University', style: TextStyle(color: Colors.white),),),
      sideBar: _sideBar.sideBarMenus(context, LearnerScreen.id),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            StreamBuilder(
              stream: learners.learnerCollection
                      ?.where('etatcompte', whereIn: [true, false])
                      ?.snapshots(),

              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.connectionState == ConnectionState.active) {
                  learn = snapshot.data.docs.map((e) => Learner.fromMap(e.data())).toList(growable: true)..sort((a, b) => a.etatCompte.toString().compareTo(b.etatCompte.toString()));
                  var learnerData = LearnerDataSource(learn, context);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Divider(thickness: 2,),
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 15,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                        child: PaginatedDataTable(
                            header: Text(
                              'Liste des Apprenants',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            rowsPerPage: 9,

                            columns: [
                              DataColumn(label: Text('Nom', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                              DataColumn(label: Text('Prénom', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                              DataColumn(label: Text('Adresse mail', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                              DataColumn(label: Text('CIN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                              DataColumn(label: Text('Téléphone', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                              DataColumn(label: Text('Date de naissance', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                              DataColumn(label: Text('   Détails', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                              DataColumn(label: Text('Etat', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),)),
                            ],
                            source: learnerData
                        ),
                      ),
                    ],
                  );
                } else if(snapshot?.connectionState == ConnectionState?.waiting) {
                  return LinearProgressIndicator();
                } else {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.warning),
                        ),
                        Text('Error in loading data')
                      ],
                    ),
                  );
                 }
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*

 */