
import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:formagil_app_admin/models/survey.dart';
import 'package:formagil_app_admin/shared/showDialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart' as prefix;
import 'package:slimy_card/slimy_card.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class SurveyTile extends StatefulWidget {
  final Survey survey;
  SurveyTile({this.survey});
  @override
  _SurveyTileState createState() => _SurveyTileState();
}

ShowDialog sh = ShowDialog();
class _SurveyTileState extends State<SurveyTile> {

  @override
  Widget build(BuildContext context) {
          return ListView(
            children: <Widget>[
              SizedBox(height: 50),

              // SlimyCard is being called here.
              SlimyCard(
                width: 350,
                topCardHeight: 261,
                bottomCardHeight: 110,
                // slimeEnabled: true,
                // In topCardWidget below, imagePath changes according to the
                // status of the SlimyCard(snapshot.data).
                topCardWidget: topCardWidget(widget.survey, context),
                bottomCardWidget: bottomCardWidget(widget.survey),
              ),
            ],
          );
  }
}

Widget topCardWidget(Survey survey, BuildContext context) {
  double bardislike = 0;
  double barlike = 0;
  double pointer = 0;
  int total = 0;

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          RawMaterialButton(
            child: Icon(Icons.highlight_remove_rounded, color: Color(0xffe51d1a),),
            onPressed: () async {
              final ConfirmAction action = await sh.asyncConfirmDialog(context,
                title: 'Suppression du Sondage',
                message: 'Êtes-vous sûr de supprimer ce sondage?',
                actionBtn: 'Supprimer',
              );
              if(action == ConfirmAction.Accept){
                var surveyQuery = FirebaseFirestore.instance.collection('survey').where('titre', isEqualTo: survey.title);
                surveyQuery.get().then((value) {
                  value.docs.forEach((element) {
                    element.reference.delete();
                  });
                });
              }
            },
            elevation: 1.0,
            constraints: BoxConstraints(), //removes empty spaces around of icon
            shape: CircleBorder(),
          ),
        ],
      ),
      InkWell(
        onTap: () async {
          total = survey.like.length + survey.dislike.length;
          barlike = survey.like.length != 0 ? (int.parse(survey.like.length.toString()) / total) * 100 : 0;
          bardislike = survey.dislike.length != 0 ? (int.parse(survey.dislike.length.toString()) / total) * 100 : 0;
          pointer = bardislike;

         await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  content: Stack(
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Positioned(
                        right: -40.0,
                        top: -40.0,
                        child: InkResponse(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: CircleAvatar(
                            child: Icon(CupertinoIcons.clear),
                            backgroundColor: Color(0xffe51d1a),
                          ),
                        ),
                      ),
                      Container(
                        width: 450,
                        height: 430,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                          child: Column(
                            children: [
                              Container(

                                child: SfRadialGauge(
                                    enableLoadingAnimation: true,
                                    animationDuration: 2000,
                                    axes: <RadialAxis>[
                                      RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                                        GaugeRange(
                                            startValue: 0,
                                            endValue: bardislike,
                                            color: Color(0xffe51d1a),
                                            startWidth: 10,
                                            endWidth: 10),
                                        GaugeRange(
                                            startValue: 100 - barlike,
                                            endValue: 100,
                                            color: Color(0xffffde00),
                                            startWidth: 10,
                                            endWidth: 10)
                                      ], pointers: <GaugePointer>[
                                        NeedlePointer(value: pointer, needleEndWidth: 8, needleStartWidth: 1, enableAnimation: true, animationDuration: 500, enableDragging: true, needleLength: 0.5)
                                      ], annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            widget: Container(
                                                child: Text('${barlike.toStringAsFixed(1)} %',
                                                    style: TextStyle(
                                                        fontSize: 20, fontWeight: FontWeight.bold))),
                                            angle: 90,
                                            positionFactor: 0.5)
                                      ])
                                    ]),
                              ),
                              barlike != 0 ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: Color(0xffffde00),
                                    ),
                                    SizedBox(width: 5,),
                                    Text('Le pourcentage de nombre like   ')
                                  ],
                                ),
                              ) : Container(),
                              bardislike != 0 ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      color: Color(0xffe51d1a),
                                    ),
                                    SizedBox(width: 5,),
                                    Text('Le pourcentage de nombre dislike')
                                  ],
                                ),
                              ) : Container(),
                            ],
                          ),
                        ),

                    ],
                  ),
                );
              });
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(image: AssetImage('assets/images/question+icon.png')),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),

      SizedBox(height: 15),
      AutoSizeText(
        survey.title,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(children: <Widget>[
                  Positioned.fill(
                    child: Container(
                      margin: EdgeInsets.all(10), // Modify this till it fills the color properly
                      color: Colors.black, // Color
                     ),
                  ),
                FaIcon(
                  FontAwesomeIcons.solidSmile,
                  color: Colors.white,
                  size: 37,
                ),
                  ]),

              SizedBox(width: 10,),
              Text(survey.like.length.toString(),
                 style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold
                 ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FaIcon(
                FontAwesomeIcons.solidAngry,
                color: Color(0xffe51d1a),
                size: 37,
              ),
              SizedBox(width: 10,),
              Text(survey.dislike.length.toString(),
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ],
      ),
      SizedBox(height: 10),
    ],
  );
}

// This widget will be passed as Bottom Card's Widget.
Widget bottomCardWidget(Survey survey) {
  return Column(
    children: [
      Text('Sujet',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12
        ),
      ),
      AutoSizeText(
        survey.subject,
        maxLines: 4,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );
}

