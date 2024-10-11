import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/screens/Former/screens/LoginFormer.dart';
import 'package:formagil_app_admin/screens/Former/services/sidebar.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/services/firebase_services.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


DatabaseService _services = DatabaseService();
class ProfilScreen extends StatefulWidget {
  static const String id = 'profil-former';

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}
User user = FirebaseAuth.instance.currentUser;


class _ProfilScreenState extends State<ProfilScreen> {


  FilePickerResult file;
  Future getPdf() async {
    file = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf']);

    if(file != null) {
      PlatformFile f = file.files.first;
      return f;
    } else {
      // User canceled the picker
    }
    // savePdf(file.files.first.bytes);
  }
  PlatformFile mediaPdf;
  String _password;
  String _newpassword;
  String _newconfirmepassword;
  bool obscureTextPassword = true;
  bool obscureTextNewPassword = true;
  bool obscureTextConfirmePassword = true;

  void togglePasswordView() async {
    setState(() {
      obscureTextPassword = !obscureTextPassword;
    });
  }
  void toggleNewPasswordView() async {
    setState(() {
      obscureTextNewPassword = !obscureTextNewPassword;
    });
  }
  void toggleConfirmePasswordView() async {
    setState(() {
      obscureTextConfirmePassword = !obscureTextConfirmePassword;
    });
  }

  final _formKey = GlobalKey<FormState>();
  ShowDialog sh = ShowDialog();
  // ShowDialog _shd = ShowDialog();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Former>(
      stream: FirebaseServices().formerUser,
      builder: (context, snapshot) {
        SideBarWidgetFormer _sideBar = SideBarWidgetFormer(uid: snapshot?.data?.uid);
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
                  Navigator.of(context).pushNamedAndRemoveUntil(LoginFormer.id, (Route<dynamic> route) => false);
                },
              ),
            ],
            title: const Text('Agil Corporate University', style: TextStyle(color: Colors.white),),),
          sideBar: _sideBar.sideBarMenus(context, ProfilScreen.id),
          body: Container(
            child: StreamBuilder<Former>(
              stream: DatabaseService(uid: user.uid).former,
              builder: (context, snapshot) {
                Former former = snapshot.data;
                if(snapshot.hasData){
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(

                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                            'assets/images/background_image_login_former.jpg'
                        ),
                      ),
                    ),
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(16),
                    child: Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Center(
                        child: Card(
                          color: Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RawMaterialButton(
                                        child: Tooltip(message: "Changer votre mot de passe", child: Icon(Icons.lock_outline, color: Colors.black, size: 30,),),
                                        onPressed: () {
                                          Alert(
                                              context: context,
                                              title: 'Changer le mot de passe',
                                              content: StatefulBuilder(
                                                builder: (context, StateSetter setState){
                                                  void _changePassword(String newpassword) async{
                                                    User user = FirebaseAuth.instance.currentUser;
                                                    user.updatePassword(newpassword).then((_){
                                                      user.reload();
                                                      print("Successfully changed password");
                                                    }).catchError((error){
                                                      print("Password can't be changed" + error.toString());
                                                    });
                                                  }

                                                  return Container(
                                                    width: 250,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      mainAxisSize: MainAxisSize.max,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Form(
                                                          key: _formKey,
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(height: 20,),
                                                                    TextFormField(
                                                                      obscureText: obscureTextPassword,
                                                                      validator: (value) => value.isEmpty ? 'Enter Password' : null,
                                                                      onChanged: (value) => _password = value,
                                                                      style: TextStyle(color: Color(0xff221e1f)),
                                                                      cursorColor: Color(0xff221e1f),
                                                                      decoration: InputDecoration(
                                                                          labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                                          hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                                          fillColor: Color(0xff221e1f),
                                                                          labelText: 'Mot de Passe',
                                                                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                                          border: OutlineInputBorder(),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                  color: Theme.of(context).primaryColor,
                                                                                  width: 2
                                                                              )
                                                                          ),
                                                                        suffixIcon: IconButton(
                                                                                icon: Icon(
                                                                                  // Based on passwordVisible state choose the icon
                                                                                  obscureTextPassword ? Icons.visibility
                                                                                      : Icons.visibility_off,
                                                                                  color: Colors.black,
                                                                                ),

                                                                                 onPressed: () {
                                                                                  setState(() {
                                                                                    togglePasswordView();
                                                                                    print(obscureTextPassword);
                                                                                  });

                                                                                 }
                                                                         ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 20,),
                                                                    TextFormField(
                                                                      obscureText: obscureTextNewPassword,
                                                                      cursorColor: Color(0xff221e1f),
                                                                      validator: (value) => value.isEmpty ? 'Enter new Password' : null,
                                                                      onChanged: (value) => _newpassword = value,
                                                                      style: TextStyle(color: Color(0xff221e1f)),
                                                                      decoration: InputDecoration(
                                                                          labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                                          hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                                          fillColor: Color(0xff221e1f),
                                                                          labelText: 'Nouveau mot de Passe',
                                                                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                                          border: OutlineInputBorder(),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                  color: Theme.of(context).primaryColor,
                                                                                  width: 2
                                                                              )
                                                                          ),
                                                                        suffixIcon: InkWell(
                                                                          child: Icon(
                                                                          // Based on passwordVisible state choose the icon
                                                                            obscureTextNewPassword ? Icons.visibility
                                                                            : Icons.visibility_off,
                                                                            color: Colors.black,
                                                                          ),

                                                                            onTap: () {
                                                                              setState(() {
                                                                                toggleNewPasswordView();
                                                                              });

                                                                            }
                                                                    ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 20,),
                                                                    TextFormField(
                                                                      obscureText: obscureTextConfirmePassword,
                                                                      cursorColor: Color(0xff221e1f),
                                                                      validator: (value) => value.isEmpty ? 'Enter new Password' : null,
                                                                      onChanged: (value) => _newconfirmepassword = value,
                                                                      style: TextStyle(color: Color(0xff221e1f)),
                                                                      decoration: InputDecoration(
                                                                          labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                                          hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                                          fillColor: Color(0xff221e1f),
                                                                          labelText: 'Confirmer',
                                                                          contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                                          border: OutlineInputBorder(),
                                                                          focusedBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                  color: Theme.of(context).primaryColor,
                                                                                  width: 2
                                                                              )
                                                                          ),
                                                                        suffixIcon: InkWell(
                                                                            child: Icon(
                                                                              // Based on passwordVisible state choose the icon
                                                                              obscureTextConfirmePassword ? Icons.visibility
                                                                                  : Icons.visibility_off,
                                                                              color: Colors.black,
                                                                            ),

                                                                            onTap: () {
                                                                              setState(() {
                                                                                toggleConfirmePasswordView();
                                                                              });

                                                                            }
                                                                        ),

                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              Center(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                  children: [
                                                                    FlatButton(
                                                                        onPressed: () async {
                                                                                bool passwordValid;
                                                                                bool newpasswordValid;
                                                                                if (_formKey.currentState.validate()) {
                                                                                  final ConfirmAction action = await sh.asyncConfirmDialog(context,
                                                                                    title: 'Mise à jour',
                                                                                    message: 'Êtes-vous sûr de modifier votre mot de passe?',
                                                                                    actionBtn: 'Modifier',
                                                                                  );
                                                                                  if(action == ConfirmAction.Accept){
                                                                                     if(former.password == _password){
                                                                                        if(_newpassword == _newconfirmepassword){
                                                                                          if(_password != _newpassword){
                                                                                            var passwordQuery = FirebaseFirestore.instance.collection('former').where("email", isEqualTo: former.email);
                                                                                            passwordQuery.get().then((value) {
                                                                                              value.docs.forEach((element) {
                                                                                                element.reference.update({
                                                                                                  'password': _newpassword
                                                                                                });
                                                                                              });
                                                                                            });
                                                                                            _changePassword(_newpassword);
                                                                                            Navigator.of(context).pop();
                                                                                          } else {
                                                                                            sh.showMyDialog(
                                                                                                context,
                                                                                                title: 'Incorrect',
                                                                                                message: 'L\'ancien mot de passe et le nouveau sont identiques !'
                                                                                            );
                                                                                          }
                                                                                        } else {
                                                                                          sh.showMyDialog(
                                                                                              context,
                                                                                              title: 'Incorrect',
                                                                                              message: 'Le confirmation de votre mot de passe est invalid !'
                                                                                          );
                                                                                        }
                                                                                     } else {
                                                                                       sh.showMyDialog(
                                                                                           context,
                                                                                           title: 'Incorrect',
                                                                                           message: 'Mot de passe invalid !'
                                                                                       );
                                                                                     }
                                                                                  }
                                                                                }
                                                                        },
                                                                        color: Theme.of(context).primaryColor,
                                                                        child: Text('Changer', style: TextStyle(color: Color(0xff221e1f)),)
                                                                    ),
                                                                  ],
                                                                ),

                                                              ),
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
                                        elevation: 1.0,
                                        constraints: BoxConstraints(), //removes empty spaces around of icon
                                        shape: CircleBorder()
                                    ),
                                    RawMaterialButton(

                                        child: Tooltip(message: "Modifier votre données", child: Icon(FontAwesomeIcons.edit, color: Colors.black,),),
                                        onPressed: () {
                                          Alert(
                                              context: context,
                                              title: 'Modification de profil',
                                              content: StatefulBuilder(
                                                builder: (context, StateSetter setState){
                                                  var _firstnameTextController = TextEditingController(text: former.nom);
                                                  var _lastnameTextController = TextEditingController(text: former.prenom);
                                                  var _phoneTextController = TextEditingController(text: former.numtel);

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
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Container(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(height: 20,),
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
                                                                    SizedBox(height: 20,),
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
                                                                    SizedBox(height: 20,),
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
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              Center(
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  mainAxisSize: MainAxisSize.max,
                                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                                    children: [
                                                                      FlatButton(
                                                                            onPressed: () async {
                                                                              if (_formKey.currentState.validate()) {
                                                                                final ConfirmAction action = await sh.asyncConfirmDialog(context,
                                                                                  title: 'Mise à jour du profil',
                                                                                  message: 'Êtes-vous sûr de modifier ce profil?',
                                                                                  actionBtn: 'Modifier',
                                                                                );
                                                                                if(action == ConfirmAction.Accept){
                                                                                  var emailQuery = FirebaseFirestore.instance.collection('former').where("email", isEqualTo: former.email);
                                                                                  emailQuery.get().then((value) {
                                                                                    value.docs.forEach((element) {
                                                                                      element.reference.update({
                                                                                        'nom': _firstnameTextController.text,
                                                                                        'prenom': _lastnameTextController.text,
                                                                                        'telephone': _phoneTextController.text,
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

                                                                    ],
                                                                  ),

                                                                ),
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
                                          elevation: 1.0,
                                          constraints: BoxConstraints(), //removes empty spaces around of icon
                                          shape: CircleBorder()
                                      ),
                                  ],
                                ),

                                CircleAvatar(
                                  child: Text(former.nom.substring(0,1), style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                                  radius: 65.0,
                                ),
                                Text(
                                  '${former.nom} ${former.prenom}',
                                  style: TextStyle(fontSize: 32.0),
                                ),
                                Container(
                                  width: 400,
                                  child: Column(
                                    children: [
                                      Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                              children: [
                                                  ListTile(
                                                    title: Text('Nom', style: TextStyle(fontSize: 17),),
                                                    trailing: Text('${former.nom}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                                  ),
                                                ],
                                              )
                                      ),
                                      Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text('Prenom', style: TextStyle(fontSize: 17),),
                                                trailing: Text('${former.prenom}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                              ),
                                            ],
                                          )
                                      ),
                                      Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text('email', style: TextStyle(fontSize: 17),),
                                                trailing: Text('${former.email}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                              ),
                                            ],
                                          )
                                      ),
                                      Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text('Numéro du téléphone', style: TextStyle(fontSize: 17),),
                                                trailing: Text('${former.numtel}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                              ),
                                            ],
                                          )
                                      ),
                                      Card(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text('Date de Naissance', style: TextStyle(fontSize: 17),),
                                                trailing: Text('${former.dateNaissance}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
                                              ),
                                            ],
                                          )
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }
            ),
          ),
        );
      }
    );
  }
}
