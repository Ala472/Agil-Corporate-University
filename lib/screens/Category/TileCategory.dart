import 'package:flutter/material.dart';
import 'package:formagil_app_admin/models/category.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screen_util.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CategoryTile extends StatefulWidget {

  final Category category;
  CategoryTile({ this.category });

  @override
  _CategoryTileState createState() => _CategoryTileState();
}
ShowDialog _shd = ShowDialog();
DatabaseService _services = DatabaseService();
final _formKey = GlobalKey<FormState>();
class _CategoryTileState extends State<CategoryTile> {
  ShowDialog sh = ShowDialog();
  @override
  Widget build(BuildContext context) {
    var _titreTextController = TextEditingController(text: widget.category.title);
    return Center(
      child: Card(
        color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(widget.category.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700
                  ),
                ),
                subtitle: Text('Crée le: ${widget.category.date}'),
                trailing: Image.asset(
                    'assets/images/hat.png',
                     fit: BoxFit.contain,
                     width: 50,
                     height: 40,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff221e1f),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10),),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Supprimer'),
                      onPressed: () async {
                        final ConfirmAction action = await sh.asyncConfirmDialog(context,
                          title: 'Suppression de module',
                          message: 'Êtes-vous sûr de supprimer ce module?',
                          actionBtn: 'Supprimer',
                        );
                        if(action == ConfirmAction.Accept){
                          var titleQuery = FirebaseFirestore.instance.collection('category').where('titre', isEqualTo: widget.category.title);
                          titleQuery.get().then((value) {
                            value.docs.forEach((element) {
                              element.reference.delete();
                            });
                          });
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('Modifier'),
                      onPressed: () async {
                        Alert(
                            context: context,
                            title: 'Modification de module',
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
                                                controller: _titreTextController,
                                                validator: (value) => value.isEmpty ? 'Entrez le titre s\'il vous plaît' : null,
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
                                                  "Modifier",
                                                  style: TextStyle(
                                                      color: Colors.white
                                                  ),
                                                ),
                                                color: Theme.of(context).accentColor,
                                                onPressed: () async {
                                                  bool x; // x pour tester si le titre existe dans DB
                                                  if (_formKey.currentState.validate()) {
                                                    final ConfirmAction action = await sh.asyncConfirmDialog(context,
                                                      title: 'Mise à jour du module',
                                                      message: 'Êtes-vous sûr de modifier ce module?',
                                                      actionBtn: 'Modifier',
                                                    );
                                                    await _services.getObjectCredentials(object: 'category').then((value) =>
                                                        value.docs.forEach((element) {
                                                          if(element.get('titre') == _titreTextController.text){
                                                            x = true; //true signifie existe dans la base
                                                          }
                                                        }));
                                                    if(action == ConfirmAction.Accept){
                                                      if(x == true && _titreTextController.text != widget.category.title){
                                                        _shd.showMyDialog(
                                                            context,
                                                            title: 'Titre déja existe',
                                                            message: 'Saisir un autre titre SVP !'
                                                        );
                                                      }
                                                      else {
                                                        var categoryQuery = FirebaseFirestore.instance.collection('category').where('titre', isEqualTo: widget.category.title);
                                                        categoryQuery.get().then((value) {
                                                          value.docs.forEach((element) {
                                                            element.reference.update({
                                                              'titre': _titreTextController.text,
                                                            });
                                                          });
                                                        });
                                                        Navigator.of(context).pop();
                                                      }
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
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          shadowColor: Color(0xffffde00),

      ),
    );
  }
}
