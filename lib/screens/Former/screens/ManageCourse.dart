
import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:formagil_app_admin/models/Course.dart';
import 'package:formagil_app_admin/models/former.dart';
import 'package:formagil_app_admin/screens/Cours/ListCourse.dart';
import 'package:formagil_app_admin/services/firebase_services.dart';
import 'package:formagil_app_admin/shared/normalProgress.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:formagil_app_admin/screens/Former/screens/LoginFormer.dart';
import 'package:formagil_app_admin/screens/Former/services/sidebar.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ManageCourse extends StatefulWidget {
  static const String id = 'manage-course';


  @override
  _ManageCourseState createState() => _ManageCourseState();
}

DatabaseService _services = DatabaseService();


const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class _ManageCourseState extends State<ManageCourse> {
  final _formKey = GlobalKey<FormState>();
  NormalProgress _nrp = NormalProgress();

  String nameMedia;
  ShowDialog _shd = ShowDialog();

  var mediaVideo;
  var mediaImage;
  var mediaPlaceholder;
  PlatformFile mediaPdf;
  DateTime now = DateTime.now();
  Widget progress;
  fb.UploadTask _uploadTask;
  fb.UploadTask _uploadTaskPlaceHolder;
  String _ratingController;
  String _category;
  bool visibility = false;

  var _inputTextController = TextEditingController();
  var _placeholderTextController = TextEditingController();
  String rand;
  var _titreTextController = TextEditingController();
  var _descriptionTextController = TextEditingController();

  Future<MediaInfo> imagePicker() async {
    MediaInfo mediaInfo = await ImagePickerWeb.getImageInfo;
    return mediaInfo;
  }
  Future<MediaInfo> videoPicker() async {
    MediaInfo mediaInfo = await ImagePickerWeb.getVideoInfo;
    return mediaInfo;
  }

  Future getPdf() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
        allowCompression: false, allowMultiple: false,
        type: FileType.custom, allowedExtensions: ['pdf']);

    if(file != null) {
      PlatformFile f = file.files.first;
      return f;
    } else {
      // User canceled the picker
    }
    // savePdf(file.files.first.bytes);
  }
  /// Upload file to firebase storage and updates [_uploadTask] to the latest
  /// file upload
  uploadFile({MediaInfo mediaInfo, String ref, String fileName}) async {
    String mimeType = mime(p.basename(mediaInfo.fileName));
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // html.File mediaFile =
    //     new html.File(mediaInfo.data, mediaInfo.fileName, {'type': mimeType});

    var metadata = fb.UploadMetadata(
      contentType: mimeType,
    );
    setState(() {
      _uploadTask = fb
          .storage()
          .ref(ref)
          .child(fileName)
          .put(mediaInfo.data, metadata);
    });


    return _uploadTask;
  }

  uploadPlaceHolder({MediaInfo mediaInfo, String ref, String fileName}) async {
    String mimeType = mime(p.basename(mediaInfo.fileName));
    var metadata = fb.UploadMetadata(
      contentType: mimeType,
    );
    setState(() {
      _uploadTaskPlaceHolder = fb
          .storage()
          .ref(ref)
          .child(fileName)
          .put(mediaInfo.data, metadata);
    });
  }

  Future uploadPdf({List<int> asset, String fileName}) async  {
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    setState(()  {
      _uploadTask = fb
          .storage()
          .ref('FichierPDF')
          .child(fileName)
          .put(asset);
    });
    return _uploadTask;
  }

  StreamBuilder progressBuilder(){
    return StreamBuilder(
      stream: _uploadTask?.onStateChanged,
      builder: (_, snapshot) {
        var event = snapshot?.data;

        // Default as 0
        double progressPercent = event != null
            ? event.bytesTransferred / event.totalBytes * 100
            : 0;

        double res = event != null ? (event.bytesTransferred / 1024.0) / 1000 : 0;
        double res2 = event != null ? (event.totalBytes / 1024.0) / 1000 : 0;

        if (progressPercent == 100) {
          //  // visibility = false;

          event = null;
          return SizedBox(height: 16,);
        } else if (progressPercent == 0) {
          return SizedBox(height: 16,);
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Text('Transfert en cours... ${progressPercent.toStringAsFixed(1)}%',),
              ),
              Container(
                child: Text('${res.toStringAsFixed(2)} MB sur ${res2.toStringAsFixed(2)} MB'),
              )
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // _ratingController = null;
    // _category = null;
    // _inputTextController.clear();
    // _titreTextController.clear();
    // _descriptionTextController.clear();
    // _placeholderTextController.clear();

    return StreamProvider<List<Course>>.value(
      value: DatabaseService()?.cours,
        child: StreamBuilder<Former>(
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
                title: const Text('Agil Corporate University', style: TextStyle(color: Colors.white),),
              ),
              sideBar: _sideBar.sideBarMenus(context, ManageCourse.id),
              body: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: progressBuilder(),
                        ),
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
                                    child: Text('Mes Cours')
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: FlatButton.icon(
                                    splashColor: Colors.transparent,
                                    onPressed: () {
                                      Alert(
                                        context: context,
                                        title: "Déposer un nouveau cours",
                                        content: StatefulBuilder(
                                          builder: (context, StateSetter setState){
                                             void changed(String field){
                                               if(field == 'Vidéos'){
                                                 visibility = true;
                                               } else {
                                                 visibility = false;
                                               }
                                             }
                                            return Column(
                                              children: [

                                                StreamBuilder<QuerySnapshot>(
                                                    stream: FirebaseFirestore?.instance?.collection('category')?.snapshots(),
                                                    builder: (_, snapshot){
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: CupertinoActivityIndicator(),
                                                        );
                                                      }
                                                      BuildContext ctx = context;
                                                      var _queryCat;

                                                      bool dropDown;
                                                      var length = snapshot.data.docs.length;
                                                      DocumentSnapshot ds = snapshot.data.docs[length - 1];
                                                      _queryCat = snapshot.data.docs;

                                                      return Container(
                                                        width: 400,
                                                        child: Form(
                                                          key: _formKey,
                                                          child: Column(
                                                            children: [
                                                              DropdownButtonFormField(
                                                                value: _category,
                                                                isDense: true,
                                                                validator: (value) => value == null ? 'Champ Obligatoire' : null,
                                                                decoration: InputDecoration(
                                                                    labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                                    hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                                    fillColor: Color(0xff221e1f),
                                                                    labelText: 'Choisir un Catégorie',
                                                                    contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                                    border: OutlineInputBorder(),
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: Theme.of(context).primaryColor,
                                                                            width: 2
                                                                        )
                                                                    )
                                                                ),
                                                                onChanged: (String newValue) {
                                                                  setState(() {
                                                                    _category = newValue;
                                                                    dropDown = false;
                                                                    print(_category);
                                                                  });
                                                                },
                                                                items: snapshot.data.docs.map((DocumentSnapshot document) {
                                                                  return DropdownMenuItem<String>(
                                                                      value: document.get('titre'),
                                                                      child: Container(
                                                                        //color: primaryColor,
                                                                        child: Text(document.get('titre')),
                                                                      )
                                                                  );
                                                                }).toList(),
                                                              ),
                                                              SizedBox(height: 10),
                                                              TextFormField(
                                                                controller: _titreTextController,
                                                                validator: (value) => value.isEmpty ? 'Champ Obligatoire' : null,
                                                                maxLength: 64,
                                                                decoration: InputDecoration(
                                                                    labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                                    hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                                    fillColor: Color(0xff221e1f),
                                                                    labelText: 'Titre du Cours',
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
                                                              DropdownButtonFormField<String>(
                                                                  value: _ratingController,
                                                                  items: ['Vidéos','Image','PDF']
                                                                      .map((label) => DropdownMenuItem(
                                                                    child: Text(label.toString()),
                                                                    value: label,
                                                                  ))
                                                                      .toList(),
                                                                  validator: (value) => value == null ? 'Champs Obligatoire' : null,
                                                                  decoration: InputDecoration(
                                                                      labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                                      hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                                      fillColor: Color(0xff221e1f),
                                                                      labelText: 'Type de Cours',
                                                                      contentPadding: EdgeInsets.only(left: 20, right: 20),
                                                                      border: OutlineInputBorder(),
                                                                      focusedBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Theme.of(context).primaryColor,
                                                                              width: 2
                                                                          )
                                                                      )
                                                                  ),

                                                                  onChanged: (value) =>
                                                                      setState(() {
                                                                        _ratingController = value;
                                                                        changed(value);
                                                                      })

                                                              ),
                                                              SizedBox(height: 10),
                                                              TextFormField(
                                                                controller: _descriptionTextController,
                                                                keyboardType: TextInputType.multiline,
                                                                maxLines: null,
                                                                validator: (value) => value.isEmpty ? 'Champ Obligatoire' : null,
                                                                decoration: InputDecoration(
                                                                    labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                                    hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                                    fillColor: Color(0xff221e1f),
                                                                    labelText: 'Description du Cours',
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
                                                                    hintText: 'Selectionner une fichier',
                                                                    suffixIcon: IconButton(
                                                                      onPressed: () async {
                                                                        if(_ratingController == 'Vidéos'){
                                                                          mediaVideo = await videoPicker();
                                                                          _inputTextController.text = mediaVideo.fileName;
                                                                        } else if(_ratingController == 'Image'){
                                                                          mediaImage = await imagePicker();
                                                                          _inputTextController.text = mediaImage.fileName;

                                                                        } else if(_ratingController == 'PDF') {
                                                                          mediaPdf = await getPdf();
                                                                          _inputTextController.text = mediaPdf.name;

                                                                          // uploadPdf(pdfMed);
                                                                        }
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
                                                              SizedBox(height: 10),
                                                              Visibility(
                                                                visible: visibility,
                                                                child: TextFormField(
                                                                  readOnly: true,
                                                                  enabled: visibility ? true : false,
                                                                  controller: visibility ? _placeholderTextController : null,
                                                                  validator: visibility ? (value) => value.isEmpty ? 'Champ Obligatoire' : null : null,
                                                                  decoration: InputDecoration(
                                                                      labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                                      hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                                      fillColor: Color(0xff221e1f),
                                                                      hintText: 'Selectionner une capture d\'écran',
                                                                      suffixIcon: IconButton(
                                                                        onPressed: () async {
                                                                          mediaPlaceholder = await imagePicker();
                                                                          _placeholderTextController.text = mediaPlaceholder.fileName;
                                                                        },
                                                                        icon: Icon(Icons.collections, color: Color(0xff221e1f),),
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
                                                              ),
                                                              SizedBox(height: 15,),
                                                              RaisedButton(
                                                                child: Text('Enregistrer'),
                                                                onPressed: () async {

                                                                  bool test;
                                                                  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                                                                  if(_formKey.currentState.validate()){
                                                                    rand = getRandomString(64);
                                                                    String placerand = getRandomString(64);
                                                                    // await _nrp.normalProgress(context, title: 'Attendez SVP Votre n\'est pas quiter le fenetre de formulaire !!!', time: 60);
                                                                    await _services.getObjectCredentials(object: 'course').then((value) =>
                                                                        value.docs.forEach((doc) {
                                                                          if(doc.get('titre') == _titreTextController.text){
                                                                            test = true;
                                                                          }
                                                                        })
                                                                    );
                                                                    if(test == true){
                                                                      _shd.showMyDialog(
                                                                          context,
                                                                          title: 'Titre de cours existe',
                                                                          message: 'Entrer autre titre SVP !'
                                                                      );
                                                                    } else {

                                                                      if(_ratingController == "Vidéos"){
                                                                        await uploadPlaceHolder(mediaInfo: mediaPlaceholder, ref: "placeholder", fileName: placerand);
                                                                        await uploadFile(mediaInfo: mediaVideo, ref: "videos", fileName: rand);
                                                                        _uploadTask.future.whenComplete(() async {
                                                                         await _services.insertCourseData(
                                                                              titre: _titreTextController.text,
                                                                              category: _category,
                                                                              type: _ratingController,
                                                                              createdAt: formattedDate,
                                                                              desc: _descriptionTextController.text,
                                                                              fileName: rand,
                                                                              fileNamePlaceholder: placerand
                                                                          );
                                                                         _ratingController = null;
                                                                         _category = null;
                                                                         _inputTextController.clear();
                                                                         _titreTextController.clear();
                                                                         _descriptionTextController.clear();
                                                                         _placeholderTextController.clear();
                                                                        });
                                                                      } else if(_ratingController == "Image") {
                                                                        await uploadFile(mediaInfo: mediaImage, ref: "images", fileName: rand);
                                                                        _uploadTask.future.whenComplete(() async {
                                                                         await _services.insertCourseData(
                                                                              titre: _titreTextController.text,
                                                                              category: _category,
                                                                              type: _ratingController,
                                                                              createdAt: formattedDate,
                                                                              desc: _descriptionTextController.text,
                                                                              fileName: rand,
                                                                              fileNamePlaceholder: _placeholderTextController.text
                                                                          );
                                                                          _ratingController = null;
                                                                          _category = null;
                                                                          _inputTextController.clear();
                                                                          _titreTextController.clear();
                                                                          _descriptionTextController.clear();
                                                                          _placeholderTextController.clear();
                                                                        });
                                                                      } else if(_ratingController == "PDF"){
                                                                        await uploadPdf(asset: mediaPdf.bytes, fileName: rand);
                                                                        _uploadTask.future.whenComplete(() async {
                                                                         await _services.insertCourseData(
                                                                              titre: _titreTextController.text,
                                                                              category: _category,
                                                                              type: _ratingController,
                                                                              createdAt: formattedDate,
                                                                              desc: _descriptionTextController.text,
                                                                              fileName: rand,
                                                                              fileNamePlaceholder: _placeholderTextController.text
                                                                          );
                                                                         _ratingController = null;
                                                                         _category = null;
                                                                         _inputTextController.clear();
                                                                         _titreTextController.clear();
                                                                         _descriptionTextController.clear();
                                                                         _placeholderTextController.clear();
                                                                        });
                                                                      }

                                                                    }

                                                                    Navigator.of(context).pop();

                                                                  }
                                                                },

                                                              ),
                                                            ],

                                                          ),

                                                        ),
                                                      );
                                                    }
                                                ),

                                              ],
                                            );
                                          },
                                        ),

                                        buttons: [
                                        //   // DialogButton(
                                        //   //   child: IconButton(
                                        //   //     icon: Icon(Icons.navigate_next),
                                        //   //     onPressed: () {},
                                        //   //   ),
                                        //   //  // onPressed: () => Navigator.pop(context),
                                        //   //   // color: Color.fromRGBO(0, 179, 134, 1.0),
                                        //   //   // radius: BorderRadius.circular(0.0),
                                        //   // ),
                                        ],
                                      ).show();
                                    },
                                    icon: Icon(Icons.add_to_photos_outlined),
                                    label: Text('Déposer un Cours'),

                                  ),
                                ),
                              ],
                            ),
                          ),

                        ),
                        Container(
                            padding: EdgeInsets.only(top: 20),
                            child: CourseList()
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        ),

    );
  }

}