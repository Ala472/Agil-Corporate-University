import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formagil_app_admin/models/learner.dart';
import 'package:formagil_app_admin/services/FireStrorageService.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LearnerDataSource extends DataTableSource {
  ShowDialog sh = ShowDialog();
  final List<Learner> learner;
  final BuildContext context;
  LearnerDataSource(this.learner, this.context);
  int _selectedCount = 0;
  DatabaseService db = DatabaseService();
  bool visibilityRecto = false;
  bool visibilityVerso = false;
  bool visibilityProfil = false;
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= learner.length) return null;
    final row = learner[index];
    return DataRow.byIndex(

        cells: [
          DataCell(Text(learner[index].nom, style: TextStyle(color: Color(0xff221e1f), fontWeight: FontWeight.w700),)),
          DataCell(Text(learner[index].prenom, style: TextStyle(color: Color(0xff221e1f), fontWeight: FontWeight.w700),)),
          DataCell(Text(learner[index].email, style: TextStyle(color: Color(0xff221e1f), fontWeight: FontWeight.w700),)),
          DataCell(Text(learner[index].cin, style: TextStyle(color: Color(0xff221e1f), fontWeight: FontWeight.w700),)),
          DataCell(Text(learner[index].numtel, style: TextStyle(color: Color(0xff221e1f), fontWeight: FontWeight.w700),)),
          DataCell(Text(learner[index].dateNaissance, style: TextStyle(color: Color(0xff221e1f), fontWeight: FontWeight.w700),)),
          DataCell(
              RawMaterialButton(
                onPressed: () async {
                 // await _nrp.normalProgress(context, title: 'Chargement en Cours', time: 70);
                  Alert(
                      context: context,
                      title: 'Validation de l\'apprenant',
                      content: StatefulBuilder(
                        builder: (context, StateSetter setState){

                          void changed(String field) async {
                            setState(() {
                              if (field == "recto"){
                                visibilityRecto = !visibilityRecto;
                              }
                              if (field == "verso"){
                                visibilityVerso = !visibilityVerso;
                              }
                              if(field == "profil"){
                                visibilityProfil = !visibilityProfil;
                              }
                            });
                          }
                          return Container(
                            width: 350,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text('Nom', style: TextStyle(fontSize: 17),),
                                          trailing: Text('${learner[index].nom}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    )
                                ),
                                Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text('Prénom', style: TextStyle(fontSize: 17),),
                                          trailing: Text('${learner[index].prenom}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    )
                                ),
                                Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text('Email', style: TextStyle(fontSize: 17),),
                                          trailing: Text('${learner[index].email}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    )
                                ),
                                Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text('Etat du compte', style: TextStyle(fontSize: 17),),
                                          trailing: learner[index].etatCompte == false ?  Text('Non Valide', style: TextStyle(color: Color(0xffe51d1a),fontSize: 17, fontWeight: FontWeight.bold),)
                                          : Text('Valide', style: TextStyle(color: Colors.green,fontSize: 17, fontWeight: FontWeight.bold),),

                                        ),
                                      ],
                                    )
                                ),
                                Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text('Adresse', style: TextStyle(fontSize: 17),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16, bottom: 10),
                                          child: Text('${learner[index].address}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    )
                                ),
                                Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text('Photo du Profil', style: TextStyle(fontSize: 17),),
                                          trailing: IconButton(
                                            onPressed: () {
                                              changed("profil");
                                            },
                                            icon: Icon(visibilityProfil ? CupertinoIcons.arrow_down_right_arrow_up_left
                                                : CupertinoIcons.arrow_up_left_arrow_down_right
                                            ),
                                            //aspect_ratio
                                          ),
                                        ),
                                        visibilityProfil ? FutureBuilder(
                                            future: _getImage(context, "Leaner/${learner[index].photoProfil}"),
                                            builder: (context, snapshot){
                                              if(snapshot.connectionState == ConnectionState.done){
                                                return Container(
                                                  height: MediaQuery.of(context).size.height / 3,
                                                  width: MediaQuery.of(context).size.width / 1.25,
                                                  child: snapshot.data,
                                                );
                                              }

                                              if(snapshot.connectionState == ConnectionState.waiting){
                                                return Container(
                                                  height: MediaQuery.of(context).size.height / 3,
                                                  width: MediaQuery.of(context).size.width / 1.25,
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                              return Container();
                                            }
                                        ) : Container(),
                                      ],
                                    )
                                ),
                                Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text('Carte Identité Recto', style: TextStyle(fontSize: 17),),
                                          trailing: IconButton(
                                            onPressed: () {
                                              changed("recto");
                                            },
                                            icon: Icon(visibilityRecto ? CupertinoIcons.arrow_down_right_arrow_up_left
                                            : CupertinoIcons.arrow_up_left_arrow_down_right
                                            ),
                                              //aspect_ratio
                                          ),
                                        ),
                                      visibilityRecto ? FutureBuilder(
                                            future: _getImage(context, "Leaner/${learner[index].identiteRecto}"),
                                            builder: (context, snapshot){
                                              if(snapshot.connectionState == ConnectionState.done){
                                                return Container(
                                                  height: MediaQuery.of(context).size.height / 3,
                                                  width: MediaQuery.of(context).size.width / 1.25,
                                                  child: snapshot.data,
                                                );
                                              }

                                              if(snapshot.connectionState == ConnectionState.waiting){
                                                return Container(
                                                  height: MediaQuery.of(context).size.height / 3,
                                                  width: MediaQuery.of(context).size.width / 1.25,
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                              return Container();
                                            }
                                        ) : Container(),
                                      ],
                                    )
                                ),
                                Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          title: Text('Carte Identité Verso', style: TextStyle(fontSize: 17),),
                                          trailing: IconButton(
                                            onPressed: () {
                                              changed('verso');
                                            },
                                            icon: Icon(visibilityVerso ? CupertinoIcons.arrow_down_right_arrow_up_left
                                                : CupertinoIcons.arrow_up_left_arrow_down_right),
                                          ),
                                        ),
                                        visibilityVerso ? FutureBuilder(
                                            future: _getImage(context, "Leaner/${learner[index].identiteVerso}"),
                                            builder: (context, snapshot){
                                              if(snapshot.connectionState == ConnectionState.done){
                                                return Container(
                                                  height: MediaQuery.of(context).size.height / 3,
                                                  width: MediaQuery.of(context).size.width / 1.25,
                                                  child: snapshot.data,
                                                );
                                              }

                                              if(snapshot.connectionState == ConnectionState.waiting){
                                                return Container(
                                                  height: MediaQuery.of(context).size.height / 3,
                                                  width: MediaQuery.of(context).size.width / 1.25,
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                              return Container();
                                            }
                                        ) : Container(),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Fermer",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      if (learner[index].etatCompte == false) DialogButton(
                          onPressed: () async {
                            final ConfirmAction action = await sh.asyncConfirmDialog(context,
                              title: 'Validation de l\'apprenant',
                              message: 'Êtes-vous sûr de valider cet apprenant?',
                              actionBtn: 'Modifier',
                            );
                            if(action == ConfirmAction.Accept){
                              var emailQuery = FirebaseFirestore.instance.collection('learner').where('email', isEqualTo: learner[index].email);
                              emailQuery.get().then((value) {
                                value.docs.forEach((element) {
                                  element.reference.update({
                                    'etatcompte': true,
                                  });
                                });
                              });
                              Navigator.of(context).pop();
                            }
                          },
                          //Navigator.pop(context),
                          child: Text(
                            "Validé",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ]).show();
                },
                shape: CircleBorder(),
                child: Icon(Icons.remove_red_eye_outlined, color: Color(0xff221e1f),),
              )
          ),
          DataCell(learner[index].etatCompte == true ? Icon(Icons.check_circle_outline_sharp, color: Colors.green,) : Icon(Icons.not_interested, color: Colors.red,)),
    ], index: index);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => learner?.length;

  @override
  int get selectedRowCount => 0;
}

Future<Widget> _getImage(context, String imageName) async {
  Image image;
  await FireStorageService.loadImage(context, imageName).then((value) {
    image = Image.network(
      value.toString(),
      fit: BoxFit.fill,
    );
  });
  return image;
}


