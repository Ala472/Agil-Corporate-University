import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Learner extends ChangeNotifier {
  String nom;
  String prenom;
  String email;
  String numtel;
  String address;
  String dateNaissance;
  String cin;
  String identiteRecto;
  String identiteVerso;
  String photoProfil;
  bool etatCompte;

  Learner({this.nom, this.prenom, this.email, this.numtel, this.address, this.dateNaissance, this.cin, this.identiteRecto,
this.identiteVerso, this.photoProfil, this.etatCompte});
  Learner.fromMap(Map<String, dynamic> map)
      : assert(map['nom'] != null ?? ''),
        assert(map['prénom'] != null),
        assert(map['email'] != null),
        assert(map['numtel'] != null),
        assert(map['adresse'] != null),
        assert(map['datenaissance'] != null),
        assert(map['cin'] != null),
        assert(map['identiterecto'] != null),
        assert(map['identiteverso'] != null),
        assert(map['profil'] != null),
        assert(map['etatcompte'] != null),

        nom = map['nom'], prenom = map['prénom'], email = map['email'], numtel = map['numtel'], address = map['adresse'],
        dateNaissance = map['datenaissance'], cin = map['cin'], identiteRecto = map['identiterecto'], identiteVerso = map['identiteverso'],
        photoProfil = map['profil'], etatCompte = map['etatcompte'];
       Learner.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data());

}


