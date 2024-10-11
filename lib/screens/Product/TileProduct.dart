import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formagil_app_admin/models/product.dart';
import 'package:formagil_app_admin/services/FireStrorageService.dart';
import 'package:formagil_app_admin/services/database.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TileProduct extends StatefulWidget {
  final Product product;
  TileProduct({this.product});

  @override
  _TileProductState createState() => _TileProductState();
}

class _TileProductState extends State<TileProduct> {
  ShowDialog sh = ShowDialog();
  final _formKey = GlobalKey<FormState>();
  DatabaseService _services = DatabaseService();
  ShowDialog _shd = ShowDialog();
  var mediaImage;

  @override
  Widget build(BuildContext context) {
    var _descriptionTextController = TextEditingController(text: widget.product.description);
    var _referenceTextController = TextEditingController(text: widget.product.ref);
    var _specificationTextController = TextEditingController(text: widget.product.specification);
    void clearText() async {
      _specificationTextController.clear();
      _descriptionTextController.clear();
      _referenceTextController.clear();
    }
    return Card(
             clipBehavior: Clip.antiAlias,
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.end,
               mainAxisSize: MainAxisSize.min,
               children: [
                 FutureBuilder<Widget>(
                     future: getImage(context, "productImage/${widget.product.fileName}"),
                     builder: (context, AsyncSnapshot snapshot){
                       if(snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.active){
                         return Container(
                           child: CircularProgressIndicator(),
                         );
                       }
                       if(snapshot.connectionState == ConnectionState.done){
                         if(snapshot.hasData){
                           return Container(
                             child: snapshot.data,
                           );
                         }
                       }


                       return Container();
                     }
                 ),
                 // Image.asset('assets/images/background_office.jpg', width: 250,),
                 ListTile(
                   leading: Icon(CupertinoIcons.cube_box),
                   title: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text('Réference: ', style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),
                       Flexible(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               AutoSizeText(
                                 widget.product.ref,
                                 maxLines: 2,
                                 style: TextStyle(fontSize: 12),
                               ),
                             ],
                           )
                       )

                     ],
                   ),
                   subtitle: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'Specification: ',
                         style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.6)),
                       ),
                       Flexible(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               AutoSizeText(
                                 widget.product.specification,
                                 maxLines: 2,
                                 style: TextStyle(fontSize: 10,color: Colors.black.withOpacity(0.6)),
                               ),
                             ],
                           ))

                     ],
                   ),
                 ),
                 Padding(
                   padding: EdgeInsets.all(10),
                   child: AutoSizeText(
                     widget.product.description,
                     maxLines: 3,
                     style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6)),
                   ),
                   // child: Text(
                   //   widget.product.description,
                   //   style: TextStyle(fontSize: 12,color: Colors.black.withOpacity(0.6)),
                   // ),
                 ),
                 Flexible(
                   child: Padding(
                     padding: EdgeInsets.only(top: 20),
                     child: ButtonBar(
                           alignment: MainAxisAlignment.center,
                           children: [
                             RawMaterialButton(
                               onPressed: () async {
                                 final ConfirmAction action = await sh.asyncConfirmDialog(context,
                                   title: 'Suppression de produit',
                                   message: 'Êtes-vous sûr de supprimer ce produit?',
                                   actionBtn: 'Supprimer',
                                 );
                                 if(action == ConfirmAction.Accept){
                                   var titleQuery = FirebaseFirestore.instance.collection('product').where('reference', isEqualTo: widget.product.ref);
                                   titleQuery.get().then((value) {
                                     value.docs.forEach((element) {
                                       element.reference.delete();
                                       FirebaseStorage.instance.ref('productImage').child(widget.product.fileName).delete();
                                     });
                                   });
                                 }
                               },
                               shape: CircleBorder(),
                               child: Icon(CupertinoIcons.delete, color: Color(0xffe51d1a),),
                             ),
                             RawMaterialButton(
                               onPressed: () async {
                                 Alert(
                                   context: context,
                                   title: "Modification du produit",
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

                                           FlatButton(
                                             child: Text('Modifier'),
                                             onPressed: () async {
                                               bool x; // x pour tester si le titre existe dans DB
                                               if (_formKey.currentState.validate()) {
                                                 final ConfirmAction action = await sh.asyncConfirmDialog(context,
                                                   title: 'Mise à jour du Produit',
                                                   message: 'Êtes-vous sûr de modifier ce produit?',
                                                   actionBtn: 'Modifier',
                                                 );
                                                 await _services.getObjectCredentials(object: 'product').then((value) =>
                                                     value.docs.forEach((element) {
                                                       if(element.get('reference') == _referenceTextController.text){
                                                         x = true;//true signifie existe dans la base
                                                       }
                                                     }));

                                                 if(action == ConfirmAction.Accept){
                                                   if(x == true && _referenceTextController.text != widget.product.ref){
                                                     _shd.showMyDialog(
                                                         context,
                                                         title: 'Réference déja existe',
                                                         message: 'Saisir un autre reference SVP !'
                                                     );
                                                   }
                                                   else {
                                                     var categoryQuery = FirebaseFirestore.instance.collection('product').where('reference', isEqualTo: widget.product.ref);
                                                     categoryQuery.get().then((value) {
                                                       value.docs.forEach((element) {
                                                         element.reference.update({
                                                           'description': _descriptionTextController.text,
                                                           'reference': _referenceTextController.text,
                                                           'specification': _specificationTextController.text,

                                                         });
                                                       });
                                                     });
                                                     Navigator.of(context).pop();

                                                   }
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
                               shape: CircleBorder(),
                               child: Icon(FontAwesomeIcons.edit, color: Color(0xffffde00),),
                             ),
                           ],
                         ),

                     ),
                   ),

               ],
             ),
           );
  }
}

Future<Widget> getImage(context, String imageName) async {
  Image image;
  await FireStorageService.loadImage(context, imageName).then((value) {
    image = Image.network(
      value.toString(),
      fit: BoxFit.contain,
      width: 200,
      height: 100,
    );
  });
   return image;
}