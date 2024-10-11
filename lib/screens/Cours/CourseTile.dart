import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:formagil_app_admin/models/Course.dart';
import 'package:formagil_app_admin/models/typeCours.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/shared/normalProgress.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:path/path.dart' as p;
import 'package:firebase/firebase.dart' as fb;

class CourseTile extends StatefulWidget with ChangeNotifier {

  final Course course;
  CourseTile({ this.course });

  @override
  _CourseTileState createState() => _CourseTileState();
}


class _CourseTileState extends State<CourseTile> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  List colors = [Colors.red, Colors.green, Colors.yellow];
  Random random = Random();
  DatabaseService _services = DatabaseService();
  ShowDialog sh = ShowDialog();
  NormalProgress _nrp = NormalProgress();
  int index = 1;

  void changeIndex() async {
    setState(() => index = random.nextInt(3));
  }

  Future<MediaInfo> imagePicker() async {
    MediaInfo mediaInfo = await ImagePickerWeb.getImageInfo;
    return mediaInfo;
  }
  Future<MediaInfo> videoPicker() async {
    MediaInfo mediaInfo = await ImagePickerWeb.getVideoInfo;
    return mediaInfo;
  }
//*******************************************************************************************
//   final mainReference = FirebaseStorage.instance.ref().child('Database');
  Future getPdf() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if(file != null) {
      return file.files.first;
    } else {
      // User canceled the picker
    }
    // savePdf(file.files.first.bytes);
  }

  Future uploadPdf({List<int> asset, String fileName}) async {
    Reference reference = FirebaseStorage.instance.ref('FichierPDF').child(fileName);
    UploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask).ref.getDownloadURL();
    documentFileUpload(url);
    return  url;
  }
  void documentFileUpload(String str) {
    var data = {
      "PDF": str,
    };
  }

//*****************************************************************************************

  Future<Uri> uploadFile({MediaInfo mediaInfo, String ref, String fileName}) async {
    try {
      String mimeType = mime(p.basename(mediaInfo.fileName));

      // html.File mediaFile =
      //     new html.File(mediaInfo.data, mediaInfo.fileName, {'type': mimeType});
      final String extension = extensionFromMime(mimeType);

      var metadata = fb.UploadMetadata(
        contentType: mimeType,
      );

      fb.StorageReference storageReference =
      fb.storage().ref(ref).child(fileName);

      fb.UploadTaskSnapshot uploadTaskSnapshot =
      await storageReference.put(mediaInfo.data, metadata).future;

      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      print("download url $imageUri");
      return imageUri;
    } catch (e) {
      print("File Upload Error $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    ShowDialog _shd = ShowDialog();
    var ctx = context;
    var _titreTextController = TextEditingController(text: widget.course.titre);

    var mediaVideo;
    var mediaImage;
    PlatformFile mediaPdf;

    var typeCourse = Provider.of<DatabaseService>(context);
    List<TypeCourse> typecours;


    return StreamBuilder(
      stream: typeCourse.typecoursCollection.where("idCours", isEqualTo: widget.course.idCourse).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          typecours = snapshot.data.docs.map((e) => TypeCourse.fromMap(e.data())).toList();

          return PageView.builder(
              itemCount: typecours?.length ?? 0,
              itemBuilder: (context, int index) {
                var _inputTextController = TextEditingController();
                var _descriptionTextController = TextEditingController(text: typecours[index].desc);

                    referenceType() {
                    if(typecours[index].type == 'Image'){
                      return 'images';
                    } else if(typecours[index].type == 'Vidéos'){
                      return 'videos';
                    } else if(typecours[index].type == 'PDF'){
                      return 'FichierPDF';
                    }
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          elevation: 5,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            children: [
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(right: 13.0),
                                  child: ListTile(
                                    title: Text(
                                      '${widget.course.titre}',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          'Publié le: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                        Text(
                                          '${widget.course.createdAt}',
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ),
                                    trailing: RawMaterialButton(
                                      child: Icon(Icons.preview),
                                      elevation: 1.0,
                                      constraints: BoxConstraints(), //removes empty spaces around of icon
                                      shape: CircleBorder(),
                                      onPressed: () {
                                        Alert(
                                          context: context,
                                          title: "Description du cours",
                                          content: Container(
                                            child: Text(typecours[index].desc),
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
                                    ),
                                  ),
                                ),
                              ),

                              Flexible(
                                child: ButtonTheme.fromButtonThemeData(
                                  data: ButtonTheme.of(context),
                                  child: ButtonBar(
                                    buttonPadding: EdgeInsetsGeometry.lerp(EdgeInsets.all(3), EdgeInsets.all(3), 2),
                                    children: [
                                      typecours[index].type == 'Image'
                                          ? Tooltip(message: typecours[index].fileName, child: Icon(Icons.image_rounded))
                                          : typecours[index].type == 'PDF'
                                          ? Tooltip(message: typecours[index].fileName, child: Icon(Icons.picture_as_pdf_rounded))
                                          : Tooltip(message: typecours[index].fileName, child: Icon(Icons.video_collection_rounded)),
                                      SizedBox(width: 8,),
                                      RawMaterialButton(
                                        onPressed: () async {
                                          final ConfirmAction action = await sh.asyncConfirmDialog(context,
                                            title: 'Suppression de cours',
                                            message: 'Êtes-vous sûr de supprimer ce cours?',
                                            actionBtn: 'Supprimer',
                                          );
                                          if(action == ConfirmAction.Accept){
                                            var courseQuery = FirebaseFirestore.instance.collection('course').where('titre', isEqualTo: widget.course.titre);
                                            courseQuery.get().then((value) {
                                              var val = value.docs.first.reference.id;
                                              print(val);
                                              value.docs.forEach((element) {
                                                element.reference.delete().then((value) => FirebaseFirestore.instance.collection('type_course').where('idCours', isEqualTo: val).get().then((value) {
                                                  value.docs.forEach((element) async {
                                                    element.reference.delete();
                                                   await FirebaseStorage.instance.ref(referenceType()).child(typecours[index].fileName).delete();
                                                    if(typecours[index].type == "Vidéos"){
                                                     await FirebaseStorage.instance.ref("placeholder").child(typecours[index].filePlaceHolder).delete();
                                                    }
                                                  });
                                                }));
                                              });
                                            });
                                          }
                                        }, //do your action
                                        elevation: 1.0,
                                        constraints: BoxConstraints(), //removes empty spaces around of icon
                                        shape: CircleBorder(), //circular button
                                        splashColor: Color(0xffffde00),
                                        highlightColor: Color(0xffffde00),
                                        child: Icon(Icons.highlight_remove_rounded, color: Colors.red,),
                                        padding: EdgeInsets.all(6),
                                      ),
                                      //Update
                                      RawMaterialButton(
                                        onPressed: () async {
                                          Alert(
                                            context: ctx,
                                            title: "Modification du cours",
                                            content: StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance.collection('category').snapshots(),
                                                builder: (context, snapshot){
                                                  if (!snapshot.hasData) return const Center(
                                                    child: const CupertinoActivityIndicator(),
                                                  );
                                                  var _queryCat;
                                                  // String _ratingController = typecours[index].type;
                                                  String _category = widget.course.category;
                                                  bool dropDown;
                                                  var length = snapshot.data.docs.length;
                                                  // DocumentSnapshot ds = snapshot.data.docs[length - 1];
                                                  // _queryCat = snapshot.data.docs;
                                                  return Container(
                                                    width: 400,
                                                    child: Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: [

                                                          SizedBox(height: 10,),
                                                          DropdownButtonFormField(
                                                            value: _category,
                                                            isDense: true,
                                                            validator: (value) => value == null ? 'Champ Obligatoire' : null,
                                                            decoration: InputDecoration(
                                                                labelStyle: TextStyle(color: Color(0xff221e1f)),
                                                                hintStyle: TextStyle(color: Color(0xff221e1f)),
                                                                fillColor: Color(0xff221e1f),
                                                                labelText: 'Choisir un module',
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
                                                            maxLength: 34,
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
                                                          TextFormField(
                                                            controller: _descriptionTextController,
                                                            keyboardType: TextInputType.multiline,
                                                            maxLength: 245,
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
                                                          SizedBox(height: 20,),
                                                          FlatButton(
                                                              onPressed: () async {
                                                                if (_formKey.currentState.validate()) {
                                                                  final ConfirmAction action = await sh.asyncConfirmDialog(context,
                                                                    title: 'Mise à jour du Cours',
                                                                    message: 'Êtes-vous sûr de modifier ce cours?',
                                                                    actionBtn: 'Modifier',
                                                                  );
                                                                  if(action == ConfirmAction.Accept){
                                                                // await _nrp.normalProgress(context, title: 'Attendez SVP Votre n\'est pas quiter le fenetre de formulaire !!!', time: 60);
                                                                    var coursQuery = FirebaseFirestore.instance.collection('course').where('titre', isEqualTo: widget.course.titre);
                                                                    coursQuery.get().then((value) {
                                                                      var val = value.docs.first.reference.id;
                                                                      print(val);
                                                                      value.docs.forEach((element) {
                                                                        element.reference.update({
                                                                          'category': _category,
                                                                          'titre': _titreTextController.text
                                                                        }).then((value) => FirebaseFirestore.instance.collection('type_course').where('idCours', isEqualTo: val).get().then((value) {
                                                                          value.docs.forEach((element) {
                                                                            element.reference.update({
                                                                              'description': _descriptionTextController.text,
                                                                            });
                                                                          });
                                                                        }));
                                                                      });
                                                                    });
                                                                    Navigator.of(context).pop();
                                                                  }

                                                                }
                                                              },
                                                              color: Theme.of(ctx).primaryColor,
                                                              child: Text('Modifier', style: TextStyle(color: Color(0xff221e1f)),)
                                                          ),
                                                        ],
                                                      ),

                                                    ),
                                                  );
                                                }
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
                                        }, //do your action
                                        elevation: 1.0,
                                        constraints: BoxConstraints(), //removes empty spaces around of icon
                                        shape: CircleBorder(), //circular button
                                        //background color
                                        splashColor: Color(0xffffde00),
                                        highlightColor: Color(0xffffde00),
                                        child: Icon(Icons.update, color: Color(0xffffde00),),
                                        padding: EdgeInsets.all(6),
                                      )
                                    ],
                                  ),
                                ),
                              )

                            ],
                          ),

                        ),
                      ),
                    )
                  ],
                );
              });

        } else if(snapshot.connectionState == ConnectionState.waiting) {
           return Container();
        } else {
          return Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.warning),
                ),
                Text('Error in loading data')
              ],
            ),
          );
        }
      },
    );
  }
}

