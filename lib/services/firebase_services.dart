import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:formagil_app_admin/models/former.dart';

class FirebaseServices extends ChangeNotifier {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference former = FirebaseFirestore.instance.collection('former');
  final String uid;
  User user = FirebaseAuth.instance.currentUser;

  FirebaseServices({ this.uid });
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user

  Former _formerUserFromSnapshot(DocumentSnapshot snapshot) {
    return Former(
        uid: uid ?? '',
        prenom: snapshot.get('prenom') ?? '',
        nom: snapshot.get('nom') ?? '',
        email: snapshot.get('email') ?? '',
        numtel: snapshot.get('telephone') ?? '',
        dateNaissance: snapshot.get('dateNaissance') ?? '',
        password: snapshot.get('password') ?? ''
    );
  }


  Former _formerFromFirebaseUser(User user) {
    return user != null ? Former(uid: user.uid) : '';
  }
  Stream<Former> get formerUser {
    return _auth.authStateChanges()
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_formerFromFirebaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _formerFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }


  Future updateUserData({String nom, String prenom, String telephone, String dateNaissance, String email, String password}) async {
    //update the auth

    return await former.doc().set({
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'dateNaissance': dateNaissance,
      'email': email,
      'password': password
    });
  }
  Future<QuerySnapshot> getFormerCredentials(){
    var result = FirebaseFirestore.instance.collection('former').get();
    return result;
  }

  Future<DocumentSnapshot> getAdminCredentials(String id){
    var result = FirebaseFirestore.instance.collection('admin').doc(id).get();
    return result;
  }





}
