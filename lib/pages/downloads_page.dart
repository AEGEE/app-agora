import 'dart:async';

import 'package:flutter/material.dart';

class DownloadsPageWidget extends StatefulWidget {
  const DownloadsPageWidget({Key aKey}) : super(key: aKey);
  @override
  DownloadsPage createState() => new DownloadsPage();
}

class DownloadsPage extends State<DownloadsPageWidget> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new RaisedButton(
          onPressed: () {
            // Navigate back to first screen when tapped!
            _neverSatisfied();
          },
          child: new Text('Go back!'),
        ),
      ),
    );
  }

  Future<Null> _neverSatisfied() async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text('Rewind and remember'),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text('You will never be satisfied.'),
                new Text('You\’re like me. I’m never satisfied.'),
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Regret'),
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
