import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/services/sidebar.dart';
import 'package:formagil_app_admin/mailer.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:formagil_app_admin/shared/normalProgress.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:provider/provider.dart';
import 'package:email_auth/email_auth.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'dart:math';
import 'Former/ListFormer.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

 const String emailAdmin = "ala122@gmail.com";

class FormerScreen extends StatefulWidget {
  static const String id = 'formateur-screen';

  @override
  _FormerScreenState createState() => _FormerScreenState();
}

class _FormerScreenState extends State<FormerScreen> {
  final _formKey = GlobalKey<FormState>();

  DatabaseService _services = DatabaseService();
  SendGridUtil _send = SendGridUtil();
  ShowDialog _shd = ShowDialog();
  NormalProgress _nrp = NormalProgress();
  final format = DateFormat("yyyy-MM-dd");
  var _dateTextController = TextEditingController();
  var _firstnameTextController = TextEditingController();
  var _lastnameTextController = TextEditingController();
  var _phoneTextController = TextEditingController();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  final MaterialColor _buttonTextColor = MaterialColor(0xffffde00, <int, Color> {
    50: Color(0xffffde00),
    100: Color(0xffffde00),
    200: Color(0xffffde00),
    300: Color(0xffffde00),
    400: Color(0xffffde00),
    500: Color(0xffffde00),
    600: Color(0xffffde00),
    700: Color(0xffffde00),
    800: Color(0xffffde00),
    900: Color(0xffffde00),
  });
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);

    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    void clearText() {
      _lastnameTextController.clear();
      _firstnameTextController.clear();
      _phoneTextController.clear();
      _dateTextController.clear();
      _emailTextController.clear();
    }

    var date = new DateTime.now();
    var newDate = new DateTime(date.year - 18, date.month, date.day);

    return StreamProvider<List<Former>>.value(
      value: DatabaseService().form,
      child: AdminScaffold(
        backgroundColor: Color(0xfffffef4),
        appBar: AppBar(
          backgroundColor: Color(0xff221e1f),
          iconTheme: IconThemeData(
              color: Color(0xfffffef4)
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
          title: const Text('Agil Corporate University', style: TextStyle(color: Color(0xfffffef4)),),),
        sideBar: _sideBar.sideBarMenus(context, FormerScreen.id),
        body: Stack(
          children: [
            Divider(
              height: 50,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        'assets/images/background_office.jpg'
                    ),
                  ),
                )
            ),
            SingleChildScrollView(
              child: ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                      lg: 9,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 50.0, 0.0, 0.0),
                        child: FormerList(),
                      )
                  ),

                  ResponsiveGridCol(
                    md: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 50.0, 10.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              // width: 350,
                              // height: 450,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),

                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        child: Column(
                                          children: [
                                            Text('Ajouter un Formateur', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xff221e1f)),),
                                            SizedBox(height: 20,),
                                            TextFormField(
                                              cursorColor: Color(0xff221e1f),
                                              controller: _lastnameTextController,
                                              validator: (value) => value.isEmpty ? 'Entrez votre prénom' : null,
                                              style: TextStyle(color: Color(0xff221e1f)),
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                  hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                  fillColor: Color(0xff221e1f),
                                                  labelText: 'Prénom',
                                                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                  border: OutlineInputBorder(),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(0xff221e1f),
                                                          width: 2
                                                      )
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            TextFormField(
                                              cursorColor: Color(0xffffde00),
                                              controller: _firstnameTextController,
                                              validator: (value) => value.isEmpty ? 'Entrer le nom de famille' : null,
                                              style: TextStyle(color: Color(0xff221e1f)),
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                  hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                  fillColor: Color(0xff221e1f),
                                                  labelText: 'Nom',
                                                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                  border: OutlineInputBorder(),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(0xff221e1f),
                                                          width: 2
                                                      )
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            TextFormField(
                                              cursorColor: Color(0xff221e1f),
                                              controller: _phoneTextController,
                                              autocorrect: true,
                                              validator: (value) {
                                                if(value.isEmpty){
                                                  return 'Entrez le numéro de téléphone';
                                                } else if(!(value.startsWith('2') || value.startsWith('5')
                                                    || value.startsWith('7') || value.startsWith('9'))){
                                                   return 'Saisissez un numéro valide!';
                                                } else if(!(value.length == 8)){
                                                  return 'Saisissez un numéro de 8 chiffre';
                                                }
                                                return null;
                                              },
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                WhitelistingTextInputFormatter.digitsOnly
                                              ],
                                              style: TextStyle(color: Color(0xff221e1f)),
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                  hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                  fillColor: Color(0xff221e1f),
                                                  labelText: 'Numéro du téléphone',
                                                  prefixIcon: Icon(Icons.phone_outlined, color: Color(0xff221e1f),),
                                                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                  border: OutlineInputBorder(),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(0xff221e1f),
                                                          width: 2
                                                      )
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            DateTimeField(
                                              format: format,
                                              controller: _dateTextController,
                                              cursorColor: Color(0xff221e1f),
                                              style: TextStyle(color: Color(0xff221e1f)),
                                              onShowPicker: (context, currentValue) {
                                                return showDatePicker(
                                                    context: context,
                                                    firstDate: DateTime(1800),
                                                    initialDate: currentValue ?? newDate,
                                                    lastDate: newDate,
                                                    builder: (BuildContext context, Widget child){
                                                      return Theme(
                                                          data: ThemeData(
                                                            primarySwatch: _buttonTextColor,
                                                            primaryColor: Color(0xff221e1f),
                                                            accentColor: Color(0xff221e1f),
                                                          ),
                                                          child: child
                                                      );
                                                    }
                                                );
                                              },
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                  hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                  fillColor: Color(0xff221e1f),
                                                  labelText: 'Date du naissance',
                                                  prefixIcon: Icon(Icons.calendar_today_outlined, color: Color(0xff221e1f),),
                                                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                  border: OutlineInputBorder(),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(0xff221e1f),
                                                          width: 2
                                                      )
                                                  )
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            TextFormField(
                                              cursorColor: Color(0xff221e1f),
                                              controller: _emailTextController,
                                              validator: (value) {
                                                if(value.isEmpty){
                                                  return 'Saisissez un e-mail !';
                                                } else if(!regExp.hasMatch(_emailTextController.text)){
                                                  return 'Saisissez une adresse mail valide';
                                                }
                                                return null;

                                              },
                                              style: TextStyle(color: Color(0xff221e1f)),
                                              decoration: InputDecoration(
                                                  labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                  hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                  fillColor: Color(0xff221e1f),
                                                  labelText: 'Email',
                                                  prefixIcon: Icon(Icons.email_outlined, color: Color(0xff221e1f),),
                                                  contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                  border: OutlineInputBorder(),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color(0xff221e1f),
                                                          width: 2
                                                      )
                                                  )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          FlatButton(
                                              onPressed: () async {
                                                String password = getRandomString(8);
                                                bool test;
                                                if(_formKey.currentState.validate()){
                                                  if(_emailTextController.text == emailAdmin){
                                                    test = true;
                                                  }
                                                    await _services.getObjectCredentials(object: 'learner').then((value) =>
                                                        value.docs.forEach((doc) {
                                                          if(doc.get('email') == _emailTextController.text){
                                                            test = true;
                                                          }
                                                        })
                                                    );
                                                    await _services.getObjectCredentials(object: 'former').then((value) =>
                                                        value.docs.forEach((doc) {
                                                          if(doc.get('email') == _emailTextController.text){
                                                            test = true;
                                                          }
                                                        })
                                                    );


                                                  if(test == true){
                                                    _shd.showMyDialog(
                                                        context,
                                                        title: 'Erreur d\'email',
                                                        message: 'Votre address mail existe'
                                                    );
                                                  } else {
                                                    await _services.insertFormerData(
                                                        nom: _lastnameTextController.text,
                                                        prenom: _firstnameTextController.text,
                                                        telephone: _phoneTextController.text,
                                                        dateNaissance: _dateTextController.text,
                                                        email: _emailTextController.text,
                                                        password: password
                                                    );
                                                    await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailAdmin, password: 'ala1221');
                                                    _send.launchURL(toMailId: _emailTextController.text, nom: _lastnameTextController.text, password: password);
                                                    clearText();
                                                  }
                                                }
                                              },
                                              color: Color(0xff221e1f),
                                              child: Text('Enregistrer', style: TextStyle(color: Color(0xffffde00)),)
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
