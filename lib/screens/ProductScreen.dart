import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:formagil_app_admin/models/product.dart';
import 'package:formagil_app_admin/screens/Product/ListProduct.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/services/sidebar.dart';
// ignore: avoid_web_libraries_in_flutter
import 'package:firebase/firebase.dart' as fb;
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html';
import 'package:path/path.dart' as p;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'LoginScreen.dart';

class ProductScreen extends StatefulWidget {
  static const String id = 'product-screen';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

DatabaseService _services = DatabaseService();
const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class _ProductScreenState extends State<ProductScreen> {

  Future<MediaInfo> imagePicker() async {
    MediaInfo mediaInfo = await ImagePickerWeb.getImageInfo;
    return mediaInfo;
  }
//*******************************************************************************************

  Future<Uri> uploadFile({MediaInfo mediaInfo, String ref, String fileName}) async {
    try {
      String mimeType = mime(p.basename(mediaInfo.fileName));

      // html.File mediaFile =
      //     new html.File(mediaInfo.data, mediaInfo.fileName, {'type': mimeType});
      final String extension = extensionFromMime(mimeType);
      var metadata = fb.UploadMetadata(contentType: mimeType,);

      fb.StorageReference storageReference = fb.storage().ref(ref).child(fileName);

      fb.UploadTaskSnapshot uploadTaskSnapshot = await storageReference.put(mediaInfo.data, metadata).future.whenComplete(() async {
        await _services.insertProductData(
          ref: _referenceTextController.text,
          desc: _descriptionTextController.text,
          spec: _specificationTextController.text,
          fileName: fileName,
        );
      });

      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      print("download url $imageUri");
      return imageUri;
    } catch (e) {
      print("File Upload Error $e");
      return null;
    }
  }
  String _ratingController;
  ShowDialog _shd = ShowDialog();
  final _formKey = GlobalKey<FormState>();
  var _descriptionTextController = TextEditingController();
  var _referenceTextController = TextEditingController();
  var _specificationTextController = TextEditingController();
  var _inputTextController = TextEditingController();
  var mediaImage;

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return StreamProvider<List<Product>>.value(
      value: DatabaseService().product,
      child: AdminScaffold(
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
                Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.id, (Route<dynamic> route) => false);
              },
            ),
          ],
          title: const Text('Agil Corporate University', style: TextStyle(color: Colors.white),),),
        sideBar: _sideBar.sideBarMenus(context, ProductScreen.id),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(50, 0.0, 50, 0.0),
                      decoration: BoxDecoration(
                        color: Color(0xffffde00),
                        borderRadius: BorderRadius.circular(7),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff221e1f).withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text('List des Produits')
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: FlatButton.icon(
                              splashColor: Colors.transparent,
                              onPressed: () {

                                Alert(
                                  context: context,
                                  title: "Déposer un nouveau produit",
                                  content: Container(
                                    width: 400,
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          TextFormField(
                                            controller: _referenceTextController,
                                            validator: (value) => value.isEmpty ? 'Champ Obligatoire' : null,
                                            maxLength: 25,
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                fillColor: Color(0xff221e1f),
                                                labelText: 'Réference',
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
                                            SizedBox(height: 10),
                                          TextFormField(
                                            controller: _descriptionTextController,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            maxLength: 135,
                                            validator: (value) => value.isEmpty ? 'Champ Obligatoire' : null,
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                fillColor: Color(0xff221e1f),
                                                labelText: 'Description',
                                                contentPadding: EdgeInsets.only(top: 20,left: 20, right: 20),
                                                border: OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context).primaryColor,
                                                        width: 2
                                                    )
                                                )
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          TextFormField(
                                            controller: _specificationTextController,
                                            keyboardType: TextInputType.multiline,
                                            maxLines: null,
                                            maxLength: 32,
                                            validator: (value) => value.isEmpty ? 'Champ Obligatoire' : null,
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                fillColor: Color(0xff221e1f),
                                                labelText: 'Spécifications',
                                                contentPadding: EdgeInsets.only(top: 20,left: 20, right: 20),
                                                border: OutlineInputBorder(),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Theme.of(context).primaryColor,
                                                        width: 2
                                                    )
                                                )
                                            ),
                                          ),
                                            SizedBox(height: 10,),
                                          TextFormField(
                                            readOnly: true,
                                            controller: _inputTextController,
                                            validator: (value) => value.isEmpty ? 'Champ Obligatoire' : null,
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                fillColor: Color(0xff221e1f),
                                                hintText: 'Selectionner une Image',
                                                suffixIcon: IconButton(
                                                  onPressed: () async {
                                                      mediaImage = await imagePicker();
                                                      _inputTextController.text = mediaImage.fileName;
                                                  },
                                                  icon: Icon(Icons.cloud_upload, color: Color(0xff221e1f),),
                                                ),
                                                contentPadding: EdgeInsets.only(top: 20,left: 20, right: 20),
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

                                          FlatButton(
                                            child: Text('Enregistrer'),
                                            onPressed: () async {
                                              bool test;
                                              if(_formKey.currentState.validate()){
                                                String rand = getRandomString(64);
                                                // await _nrp.normalProgress(context, title: 'Attendez SVP Votre n\'est pas quiter le fenetre de formulaire !!!', time: 60);
                                                await _services.getObjectCredentials(object: 'product').then((value) =>
                                                    value.docs.forEach((doc) {
                                                      if(doc.get('reference') == _referenceTextController.text){
                                                        test = true;
                                                      }
                                                    })
                                                );
                                                if(test == true){
                                                 await _shd.showMyDialog(
                                                      context,
                                                      title: 'Réference existe',
                                                      message: 'Entrer autre réference SVP !'
                                                  );
                                                } else {
                                                    await uploadFile(mediaInfo: mediaImage, ref: "productImage", fileName: rand);
                                                  _referenceTextController.clear();
                                                  _descriptionTextController.clear();
                                                  _specificationTextController.clear();
                                                  _inputTextController.clear();
                                                  Navigator.of(context).pop();
                                                }
                                              }

                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                                  ),
                                  buttons: [
                                    // DialogButton(
                                    //   child: IconButton(
                                    //     icon: Icon(Icons.navigate_next),
                                    //     onPressed: () {},
                                    //   ),
                                    //  // onPressed: () => Navigator.pop(context),
                                    //   // color: Color.fromRGBO(0, 179, 134, 1.0),
                                    //   // radius: BorderRadius.circular(0.0),
                                    // ),
                                  ],
                                ).show();
                              },
                              icon: Icon(CupertinoIcons.cube_box),
                              label: Text('Déposer un produit'),

                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 20),
                      child: ProductList()
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
// uploadFile(media, 'videos', media.fileName);
