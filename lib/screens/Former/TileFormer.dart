import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/models/typeCours.dart';
import 'package:formagil_app_admin/screens/Former/screens/ProfilScreen.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FormerTile extends StatefulWidget {

  final Former former;
  FormerTile({ this.former });

  @override
  _FormerTileState createState() => _FormerTileState();
}


class _FormerTileState extends State<FormerTile> {
  final format = DateFormat("yyyy-MM-dd");
  final _formKey = GlobalKey<FormState>();
  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = Random();
  DatabaseService db = DatabaseService();
  ShowDialog sh = ShowDialog();
  int index = 1;
  DatabaseService _services = DatabaseService();
  void changeIndex() async {
    setState(() => index = random.nextInt(3));
  }

  @override
  Widget build(BuildContext context) {
    var _firstnameTextController = TextEditingController(text: widget.former.nom);
    var _lastnameTextController = TextEditingController(text: widget.former.prenom);
    var _phoneTextController = TextEditingController(text: widget.former.numtel);
    var _dateTextController = TextEditingController(text: widget.former.dateNaissance);
    var date = new DateTime.now();
    var newDate = new DateTime(date.year - 18, date.month, date.day);
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
    List<Color> colors = [
      Colors.pink[900],
      Colors.red[900],
      Colors.deepOrange[900],
      Colors.orange[900],
      Colors.yellow[900],
      Colors.green[900],
      Colors.blue[900],
      Colors.purple[900],
      Colors.deepPurple[900],
      Colors.brown[900],
      Colors.teal[900],
      Colors.cyan[900],
      Colors.lightGreen[900],
      Colors.pinkAccent[700],
      Colors.redAccent[700],
      Colors.deepOrangeAccent[700],
      Colors.orangeAccent[700],
      Colors.yellowAccent[700],
      Colors.greenAccent[700],
      Colors.blueAccent[700],
      Colors.purpleAccent[700],
      Colors.lightBlueAccent[700],
      Colors.deepPurpleAccent[700],
      Colors.tealAccent[700],
      Colors.blueGrey[900],
    ];
    List lettre = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
    Color avatarColor;

    for (int i =0; i<lettre.length; i++){
      if(lettre[i] == widget.former.prenom.substring(0, 1).toUpperCase()){
        avatarColor = colors[i];
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Card(
            elevation: 5,
            color: Color(0xff221e1f),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(right: 13.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25.0,
                        child: Text(
                            '${widget.former.prenom.substring(0, 2).toUpperCase()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        backgroundColor: avatarColor,
                      ),
                      title: Text(
                        '${widget.former.nom} ${widget.former.prenom}',
                        style: TextStyle(color: Color(0xffffde00)),
                      ),
                      subtitle: Text(
                        '${widget.former.email}',
                        style: TextStyle(color: Color(0xffffde00)),
                      ),
                      trailing: Text(
                        '+216 ${widget.former.numtel}',
                        style: TextStyle(color: Color(0xffffde00), fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),

                Flexible(
                  child: ButtonTheme.fromButtonThemeData(
                    data: ButtonTheme.of(context),
                    child: ButtonBar(
                      buttonPadding: EdgeInsetsGeometry.lerp(EdgeInsets.all(3), EdgeInsets.all(3), 2),
                      children: [
                        RawMaterialButton(
                          onPressed: () async {
                            final ConfirmAction action = await sh.asyncConfirmDialog(context,
                            title: 'Suppression de formateur',
                            message: 'Êtes-vous sûr de supprimer ce formateur?',
                            actionBtn: 'Supprimer',
                            );
                            if(action == ConfirmAction.Accept){
                              var d;
                              var emailQuery = FirebaseFirestore.instance.collection('former').where('email', isEqualTo: widget.former.email);
                              emailQuery.get().then((value) {
                                value.docs.forEach((element) async {
                                  print(element.id);
                                  UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: widget.former.email, password: widget.former.password);
                                  User user = result.user;
                                  await user.delete();
                                  UserCredential uc = await FirebaseAuth.instance.signInWithEmailAndPassword(email:'ala122@gmail.com', password: 'ala1221');
                                  User userBefore = uc.user;
                                  element.reference.delete().then((value) => FirebaseFirestore.instance.collection('course').where('idFormer', isEqualTo: element.id).get().then((value) {
                                    value.docs.forEach((element) {
                                      element.reference.delete().then((value) {
                                        FirebaseFirestore.instance.collection('type_course').where('idCours', isEqualTo: element.id).get().then((value) {
                                          value.docs.forEach((element) {

                                            referenceType() {
                                              if(element.get('type') == 'Image'){
                                                return 'images';
                                              } else if(element.get('type') == 'Vidéos'){
                                                return 'videos';
                                              } else if(element.get('type') == 'PDF'){
                                                return 'FichierPDF';
                                              }
                                            }
                                               FirebaseStorage.instance.ref(referenceType()).child(element.get('fileName')).delete().then((value) {
                                                 element.reference.delete();
                                                 if(element.get('type') == "Vidéos"){
                                                   FirebaseStorage.instance.ref("placeholder").child(element.get('fileNamePlaceholder')).delete();
                                                 }
                                               });
                                          });

                                        });
                                      });

                                    });
                                  }));
                                });
                              });

                            }
                          }, //do your action
                          elevation: 1.0,
                          constraints: BoxConstraints(), //removes empty spaces around of icon
                          shape: CircleBorder(), //circular button
                          splashColor: Color(0xffffde00),
                          highlightColor: Color(0xffffde00),
                          child: Icon(Icons.delete_forever, color: Color(0xffffde00),),
                          padding: EdgeInsets.all(6),
                        ),
                        //Update
                        RawMaterialButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                          right: -40.0,
                                          top: -40.0,
                                          child: InkResponse(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: CircleAvatar(
                                              child: Icon(CupertinoIcons.clear),
                                              backgroundColor: Color(0xffe51d1a),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 350,
                                          height: 410,
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
                                                        Text('Mise à jour de ${widget.former.prenom}', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: Color(0xff221e1f)),),
                                                        SizedBox(height: 15,),
                                                        TextFormField(
                                                          cursorColor: Color(0xff221e1f),
                                                          controller: _lastnameTextController,
                                                          validator: (value) => value.isEmpty ? 'Enter first name' : null,
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
                                                                      color: Theme.of(context).primaryColor,
                                                                      width: 2
                                                                  )
                                                              )
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
                                                        TextFormField(
                                                          cursorColor: Color(0xff221e1f),
                                                          controller: _firstnameTextController,
                                                          validator: (value) => value.isEmpty ? 'Enter last name' : null,
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
                                                                      color: Theme.of(context).primaryColor,
                                                                      width: 2
                                                                  )
                                                              )
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
                                                        TextFormField(
                                                          cursorColor: Color(0xff221e1f),
                                                          controller: _phoneTextController,
                                                          autocorrect: true,
                                                          validator: (value) => value.isEmpty ? 'Enter phone number' : null,
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
                                                              prefixIcon: Icon(Icons.phone, color: Color(0xff221e1f),),
                                                              contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                              border: OutlineInputBorder(),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Theme.of(context).primaryColor,
                                                                      width: 2
                                                                  )
                                                              )
                                                          ),
                                                        ),
                                                        SizedBox(height: 15,),
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
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: FlatButton(
                                                            onPressed: () async {
                                                              bool test = true;
                                                              if (_formKey.currentState.validate()) {
                                                                final ConfirmAction action = await sh.asyncConfirmDialog(context,
                                                                  title: 'Mise à jour du formateur',
                                                                  message: 'Êtes-vous sûr de modifier ce formateur?',
                                                                  actionBtn: 'Modifier',
                                                                );
                                                                if(action == ConfirmAction.Accept){
                                                                  var emailQuery = FirebaseFirestore.instance.collection('former').where("email", isEqualTo: widget.former.email);
                                                                  emailQuery.get().then((value) {
                                                                    value.docs.forEach((element) {
                                                                      element.reference.update({
                                                                        'nom': _firstnameTextController.text,
                                                                        'prenom': _lastnameTextController.text,
                                                                        'telephone': _phoneTextController.text,
                                                                        'dateNaissance': _dateTextController.text
                                                                      });
                                                                    });
                                                                  });
                                                                  Navigator.of(context).pop();
                                                                }
                                                              }
                                                            },
                                                            color: Theme.of(context).primaryColor,
                                                            child: Text('Modifier', style: TextStyle(color: Color(0xff221e1f)),)
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  );
                                });
                          }, //do your action
                          elevation: 1.0,
                          constraints: BoxConstraints(), //removes empty spaces around of icon
                          shape: CircleBorder(), //circular button
                         //background color
                          splashColor: Color(0xffffde00),
                          highlightColor: Color(0xffffde00),
                          child: Icon(Icons.update, color: Color(0xffffde00),),
                          padding: EdgeInsets.all(6),
                        )
                      ],
                    ),
                  ),
                )

              ],
            ),

          ),
        )
      ],
    );
  }
}