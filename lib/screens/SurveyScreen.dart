import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:formagil_app_admin/models/survey.dart';
import 'package:formagil_app_admin/screens/Survey/SurveyList.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/services/sidebar.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'LoginScreen.dart';

DatabaseService _services = DatabaseService();
class SurveyScreen extends StatefulWidget {
  static const String id = 'survey-screen';

  @override
  _SurveyScreenState createState() => _SurveyScreenState();
}

DateTime now = DateTime.now();
final _formKey = GlobalKey<FormState>();
var _titleTextController = TextEditingController();
var _subjectTextController = TextEditingController();
ShowDialog _shd = ShowDialog();

class _SurveyScreenState extends State<SurveyScreen> {
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return StreamProvider<List<Survey>>.value(
      value: DatabaseService().survey,
      child: AdminScaffold(
        backgroundColor: Colors.white30,
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
        sideBar: _sideBar.sideBarMenus(context, SurveyScreen.id),
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
                              child: Text('Liste Des Sondages')

                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton.icon(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                Alert(
                                    context: context,
                                    title: 'Déposer un Sondage',
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
                                                      child: Column(
                                                        children: [
                                                          TextFormField(
                                                            controller: _titleTextController,
                                                            maxLength: 128,
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
                                                          SizedBox(height: 10,),
                                                          TextFormField(
                                                            controller: _subjectTextController,
                                                            keyboardType: TextInputType.multiline,
                                                            maxLines: null,
                                                            validator: (value) => value.isEmpty ? 'Enter Subject please' : null,
                                                            decoration: InputDecoration(
                                                                labelText: 'Sujet',
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
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: RaisedButton(
                                                        child: Text(
                                                          "Publier",
                                                          style: TextStyle(
                                                              color: Colors.white
                                                          ),
                                                        ),
                                                        color: Theme.of(context).accentColor,
                                                        onPressed: () async {
                                                          bool x;
                                                          List<String> likeslength = [];
                                                          List<String> dislikeslength = [];
                                                          String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                                                          if(_formKey.currentState.validate()){
                                                            await _services.getObjectCredentials(object: 'survey').then((value) {
                                                              value.docs.forEach((element) {
                                                                if(element.get('titre') == _titleTextController.text){
                                                                  x = true; //true signifie existe dans la base
                                                                }
                                                              });
                                                            });

                                                            if(x == true){
                                                              _shd.showMyDialog(
                                                                  context,
                                                                  title: 'Titre existe',
                                                                  message: 'Saisir un autre titre SVP !'
                                                              );
                                                            } else {
                                                              await _services.insertSurveyData(
                                                                  title: _titleTextController.text,
                                                                  subject: _subjectTextController.text,
                                                                  createdAt: formattedDate,
                                                                  like: likeslength,
                                                                  dislike: dislikeslength
                                                              );
                                                              _titleTextController.clear();
                                                              _subjectTextController.clear();
                                                              Navigator.of(context).pop();
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
                              icon: Icon(CupertinoIcons.share_up),
                              label: Text('Déposer Un Sondage'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      //Barometre
                    child: SurveyList(),
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
