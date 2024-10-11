import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:formagil_app_admin/screens/Category/ListCategory.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/services/sidebar.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'LoginScreen.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category-screen';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime now = DateTime.now();
  ShowDialog _shd = ShowDialog();
  
  DatabaseService _services = DatabaseService();
  var _titleTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return StreamProvider.value(
      value: DatabaseService().categories,
      child: AdminScaffold(
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
        sideBar: _sideBar.sideBarMenus(context, CategoryScreen.id),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                      decoration: BoxDecoration(
                        color: Color(0xffffde00),
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff221e1f).withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text('Liste des Modules')

                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton.icon(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                Alert(
                                    context: context,
                                    title: 'Ajouter un module',
                                    content: StatefulBuilder(
                                      builder: (context, StateSetter setState){

                                        return Container(
                                          width: 350,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.all(8.0),
                                                      child: TextFormField(
                                                        controller: _titleTextController,
                                                        validator: (value) => value.isEmpty ? 'Enter title please' : null,
                                                        decoration: InputDecoration(
                                                            labelText: 'Titre',
                                                            contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                            border: OutlineInputBorder(),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(context).accentColor,
                                                                    width: 2
                                                                )
                                                            )
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RaisedButton(
                                                        child: Text(
                                                          "Ajouter",
                                                          style: TextStyle(
                                                              color: Colors.white
                                                          ),
                                                        ),
                                                        color: Theme.of(context).accentColor,
                                                        onPressed: () async {
                                                          bool x; // x pour tester si le titre existe dans DB
                                                          String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                                                          if (_formKey.currentState.validate()) {
                                                            await _services.getObjectCredentials(object: 'category').then((value) =>
                                                                value.docs.forEach((element) {
                                                                  if(element.get('titre') == _titleTextController.text){
                                                                    x = true; //true signifie existe dans la base
                                                                  }
                                                                }));
                                                            if(x == true){
                                                              _shd.showMyDialog(
                                                                  context,
                                                                  title: 'Titre existe',
                                                                  message: 'Saisir un autre titre SVP !'
                                                              );
                                                            } else {
                                                              await _services.insertCategoryData(
                                                                title: _titleTextController.text,
                                                                date: formattedDate, );
                                                              Navigator.of(context).pop();
                                                              _titleTextController.clear();
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    buttons: [
                                      // DialogButton(
                                      //   onPressed: () => Navigator.pop(context),
                                      //   child: Text(
                                      //     "Validé",
                                      //     style: TextStyle(color: Colors.white, fontSize: 20),
                                      //   ),
                                      // )
                                    ]).show();
                              },
                                icon: Icon(CupertinoIcons.add_circled),
                                label: Text('Ajouter Un Module'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: ListCategory()
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
