import 'package:flutter/material.dart';

enum ConfirmAction { Cancel, Accept}
class ShowDialog {

  Future<ConfirmAction> asyncConfirmDialog(BuildContext context, {String title, String message, String actionBtn}) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title, style: TextStyle(color: Color(0xff221e1f), fontSize: 28, fontWeight: FontWeight.bold),),
          content: Text(
            message,
            style: TextStyle(color: Color(0xff221e1f)),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Annuler', style: TextStyle(color: Color(0xff221e1f)),),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: Text(actionBtn, style: TextStyle(color: Color(0xff221e1f)),),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Accept);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> showMyDialog(context, {message, title}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }





}