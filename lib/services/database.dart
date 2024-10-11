import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:formagil_app_admin/models/Course.dart';
import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formagil_app_admin/models/learner.dart';
import 'package:formagil_app_admin/models/product.dart';
import 'package:formagil_app_admin/models/survey.dart';
import 'package:provider/provider.dart';

class DatabaseService extends ChangeNotifier {

  final String uid;
  User user = FirebaseAuth.instance.currentUser;
  DatabaseService({ this.uid });
  // collection reference
   final FirebaseAuth _auth = FirebaseAuth.instance;
   CollectionReference formerCollection = FirebaseFirestore.instance.collection('former');
   CollectionReference categoryCollection = FirebaseFirestore.instance.collection('category');
   Query learnerCollection = FirebaseFirestore.instance.collection('learner');
   CollectionReference courseCollection = FirebaseFirestore.instance.collection('course');
   CollectionReference typecoursCollection = FirebaseFirestore.instance.collection('type_course');
   CollectionReference surveyCollection = FirebaseFirestore.instance.collection('survey');
   CollectionReference productCollection = FirebaseFirestore.instance.collection('product');

  Future insertFormerData({String nom, String prenom, String telephone, String dateNaissance, String email, String password}) async {
    //update the auth
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    User user = userCredential.user;
    return await formerCollection.doc(user.uid).set({
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'dateNaissance': dateNaissance,
      'email': email,
      'password': password
    });
  }

  Future insertCourseData({String titre, String category, String type, String desc, String fileName, String fileNamePlaceholder, String createdAt}) async {
    //update the auth
    return await courseCollection.add({
      'idFormer': FirebaseAuth.instance.currentUser.uid,
      'category': category,
      'titre': titre,
      'createdAt': createdAt
    }).then((value) => typecoursCollection.doc().set({
      'idCours': value.id,
      'type': type,
      'description': desc,
      'fileName': fileName,
      'fileNamePlaceholder': fileNamePlaceholder
    }));
  }

  Future insertSurveyData({String title, String subject, String createdAt, List<String> like, List<String> dislike}) async {
    return await surveyCollection.add({
      'titre': title,
      'subject': subject,
      'createdAt': createdAt,
      'likes': like,
      'dislike': dislike
    });
  }

  Future insertProductData({String ref, String desc, String spec, String fileName}) async {
    return await productCollection.add({
      'reference': ref,
      'description': desc,
      'specification': spec,
      'fileName': fileName,
    });
  }

  Stream<List<Survey>> get survey {
    return surveyCollection
        .snapshots()
        .map((survey) {
      return survey.docs
          .map((e) => Survey.fromJson(e.data()))
          .toList();
    });
  }




  Future insertCategoryData({String title, String date}) async {

    return await categoryCollection.add({
    'titre': title,
    'date': date
    });
  }

  // Future updateUserName(String name) async {
  //   return await user.updateProfile(displayName: name);
  // }

  // former list from snapshot



  List<Category> _categoryListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((e) => Category(
      title: e.get('titre') ?? '',
      date: e.get('date') ?? '',
    )).toList();
  }

  Stream<List<Category>> get categories {
    return categoryCollection.snapshots().map(_categoryListFromSnapshot);
  }


  List<Product> _productListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((e) => Product(
      ref: e.data()['reference'] ?? '',
      description: e.data()['description'] ?? '',
      specification: e.data()['specification'] ?? '',
      fileName: e.data()['fileName'] ?? '',
    )).toList();
  }

  Stream<List<Product>> get product {
    return productCollection.snapshots().map(_productListFromSnapshot);
  }
  //  userData from snapshot
  // List<Learner> learnersDataFromSnapshot(QuerySnapshot snapshot){
  //   return snapshot.docs.map((e) => Learner(
  //     nom: e.get('nom') ?? '',
  //     prenom: e.get('prenom') ?? '',
  //     email: e.get('email') ?? '',
  //     // numtel: e.get('numtel') ?? '',
  //     // address: e.get('adresse') ?? '',
  //     // dateNaissance: e.get('datenaissance') ?? '',
  //     // cin: e.get('cin') ?? '',
  //     // identiteVerso: e.get('identiteverso') ?? '',
  //     // identiteRecto: e.get('identiterecto') ?? '',
  //     // photoProfil: e.get('profil') ?? '',
  //     // etatCompte: e.get('etatcompte') ?? '',
  //   )).toList();
  // }


  // // get user doc stream
  // Stream<List<Learner>> get learners {
  //   return learnerCollection.snapshots().map(learnersDataFromSnapshot);
  // }

  Stream<Former> get former {
    return formerCollection.doc(uid).snapshots().map(_formerUserFromSnapshot);
  }

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

  List<Former> _formerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Former(
        nom: doc.get('nom') ?? '',
        prenom: doc.get('prenom') ?? '',
        numtel: doc.get('telephone') ?? '',
        email: doc.get('email') ?? '',
        dateNaissance: doc.get('dateNaissance') ?? '',
        password: doc.get('password') ?? '',
    )).toList();
  }

  Stream<List<Former>> get form {
    return formerCollection.snapshots().map(_formerListFromSnapshot);
  }

  List<Course> _courseListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) => Course(
        idCourse: doc.id ?? '',
        category: doc.get('category') ?? '',
        idFormer: doc.get('idFormer') ?? '',
        titre: doc.get('titre') ?? '',
        createdAt: doc.get('createdAt') ?? ''
    )).toList();
  }

   inputData() async {
    String uid = _auth.currentUser.uid;
    return uid;
    // here you write the codes to input the data into firestore
  }

  Stream<List<Course>> get cours {
    return courseCollection.where('idFormer', isEqualTo: user?.uid).snapshots().map(_courseListFromSnapshot);
  }
  // get brews streams



  Future<QuerySnapshot> getObjectCredentials({String object}){
    var result = FirebaseFirestore.instance.collection(object).get();
    return result;
  }

  Future<DocumentSnapshot> getAdminCredentials(String id){
    var result = FirebaseFirestore.instance.collection('admin').doc(id).get();
    return result;
  }

  Future<DocumentSnapshot> getFormerCredentials(){
    var result = FirebaseFirestore.instance.collection('former').doc().get();
    return result;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

