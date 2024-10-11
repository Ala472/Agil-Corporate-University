
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formagil_app_admin/screens/Former/screens/ManageCourse.dart';
import 'package:formagil_app_admin/screens/LoginScreen.dart';
import 'package:formagil_app_admin/services/firebase_services.dart';
import 'package:formagil_app_admin/shared/normalProgress.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';


class LoginFormer extends StatefulWidget {
  static const String id = 'login-former-screen';

  @override
  _LoginFormerState createState() => _LoginFormerState();
}
String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp = new RegExp(p);

class _LoginFormerState extends State<LoginFormer> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final _formKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  ShowDialog _shd = ShowDialog();
  NormalProgress _nrp = NormalProgress();

  @override
  Widget build(BuildContext context) {
     bool testUserEmail;
     bool testUserPassword;
    _login({email, password}) async {
      await _services.getFormerCredentials().then((value) async {
        value.docs.forEach((element) async {
          if(element.data()['email'] == email){
              testUserEmail = true;
            if(element.data()['password'] == password){
              testUserPassword = true;

            }
          }
        });
      });
      if(testUserEmail == true && testUserPassword == true){
        try{
          dynamic result = await _services.signInWithEmailAndPassword(email, password);
          if(result != null){

            Navigator.pushReplacementNamed(context, ManageCourse.id);
          }
        } catch(e) {
          _shd.showMyDialog(
              context,
              title: 'Login',
              message: '${e.toString()}'
          );
        }
      } else if(testUserEmail == null) {
        _shd.showMyDialog(
            context,
            title: 'Email invalide',
            message: 'L\'adresse e-mail que vous avez saisie est incorrecte'
        );
      } else if(testUserPassword == null){
        _shd.showMyDialog(
            context,
            title: 'Mot de passe incorrect',
            message: 'Le mot de passe que vous avez entré n\'est pas valide'
        );
      }
    }

    return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xff221e1f),
            title: Text('Agil Corporate University Espace Formateur', style: TextStyle(color: Color(0xffffde00), fontWeight: FontWeight.w700),),
            centerTitle: true,
            actions: [
              RaisedButton.icon(
                label: Text(
                  'Espace Administrateur',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                icon: const Icon(Icons.login, color: Color(0xffffde00),),
                color: Color(0xff221e1f),
                splashColor: Colors.amber,
                disabledTextColor: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                },
              ),
            ],
          ),
          body: FutureBuilder(
            // Initialize FlutterFire:
            future: _initialization,
            builder: (context, snapshot) {
              // Check for errors
              if (snapshot.hasError) {
                return Center(child: Text('Connection Failed'),);
              }

              // Once complete, show your application
              if (snapshot.connectionState == ConnectionState.done) {
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
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 300,
                      height: 400,
                      child: Card(
                        color: Colors.grey[100],
                        elevation: 10,
                        shadowColor: Color(0xff221e1f),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'assets/images/AGIL.1.png',
                                  width: 150,
                                  fit: BoxFit.fill,
                                ),

                                Container(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        cursorColor: Color(0xff221e1f),
                                        controller: _emailTextController,
                                        style: TextStyle(color: Color(0xff221e1f)),
                                        validator: (value) {
                                          if(value.isEmpty){
                                            return 'Saisissez votre e-mail !';
                                          } else if(!regExp.hasMatch(_emailTextController.text)){
                                            return 'Saisissez une adresse mail valide';
                                          }
                                          return null;

                                        },
                                        decoration: InputDecoration(
                                            fillColor: Color(0xff221e1f),
                                            labelText: 'Email',
                                            labelStyle: TextStyle(color: Color(0xff221e1f)),
                                            hintStyle: TextStyle(color: Color(0xff221e1f)),
                                            prefixIcon: Icon(Icons.email, color: Color(0xff221e1f),),
                                            contentPadding: EdgeInsets.only(left: 20, right: 20),
                                            border: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff221e1f),
                                                    width: 2
                                                )
                                            ),
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
                                        controller: _passwordTextController,
                                        validator: (value){
                                          if(value.isEmpty){
                                            return 'Entrez un mot de passe !';
                                          }
                                          if(value.length < 6){
                                            return 'Minimum 6 Caractére';
                                          }
                                          return null;
                                        },
                                        style: TextStyle(color: Color(0xff221e1f)),
                                        obscureText: true,
                                        decoration: InputDecoration(
                                            fillColor: Color(0xffffde00),
                                            labelText: 'Mot de Passe',
                                            labelStyle: TextStyle(color: Color(0xff221e1f)),
                                            hintStyle: TextStyle(color: Color(0xff221e1f)),
                                            prefixIcon: Icon(Icons.lock_outline, color: Color(0xff221e1f),),
                                            contentPadding: EdgeInsets.only(left: 20, right: 20),
                                            border: OutlineInputBorder(),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xff221e1f),
                                                    width: 2
                                                )
                                            ),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ButtonTheme(
                                      minWidth: 100.0,
                                      height: 55.0,
                                      child: OutlineButton(
                                        onPressed: () async {
                                          if(_formKey.currentState.validate()){
                                            _login(
                                                email: _emailTextController.text,
                                                password: _passwordTextController.text
                                            );
                                          }
                                        },
                                        child: Icon(
                                          Icons.login_outlined,
                                          color: Color(0xff221e1f),
                                          size: 25.0,
                                        ),
                                        shape: CircleBorder(),
                                        borderSide: BorderSide(
                                          color: Color(0xff221e1f),
                                          style: BorderStyle.solid,
                                          width: 2,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              // Otherwise, show something whilst waiting for initialization to complete
              return CircularProgressIndicator();
            },
          )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
