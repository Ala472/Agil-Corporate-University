import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class NormalProgress {

     normalProgress(context, {String title, int time}) async {
     /// Create progress dialog
     ProgressDialog pd = ProgressDialog(context: context);

     /// Set options
     /// Max and msg required
     pd.show(
         max: 100,
         msg: title,
         progressType: ProgressType.valuable,
         backgroundColor: Color(0xff221e1f),
         progressValueColor: Color(0xffffde00),
         progressBgColor: Color(0xff221e1f),
         msgColor: Colors.white,
         valueColor: Colors.white);

     for (int i = 0; i <= 100; i++) {
       /// You don't need to update state, just pass the value.
       /// Only value required
       pd.update(value: i);
       i++;
       await Future.delayed(Duration(milliseconds: time));
     }
   }
}