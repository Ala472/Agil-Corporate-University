import 'package:firebase/firebase.dart';
import 'package:flutter/cupertino.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService() {
    initializeApp(
      apiKey: "AIzaSyDDFA211kl8Ef9Qr3WyD5jkGbNMV0ORv5Q",
      authDomain: "agil-data.firebaseapp.com",
      databaseURL: "https://agil-data-default-rtdb.firebaseio.com",
      projectId: "agil-data",
      storageBucket: "agil-data.appspot.com",
      messagingSenderId: "307197845414",
    );
  }
  static Future<dynamic> loadImage(BuildContext context, String image) async {
    var url = await storage().ref(image).getDownloadURL();
    return url;
  }
}
