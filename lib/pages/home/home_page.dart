import 'dart:async';

import 'package:flutter/material.dart';
import '../../utils/firebase_data.dart';
import '../map/map_page.dart';
import '../schedule/schedule_page.dart';
import '../contact/contact_page.dart';
import '../links/links_page.dart';
import '../news/news_page.dart';
import '../login/login_page.dart';

HomePage gHomePage = new HomePage();

class MenuItem extends StatelessWidget {
  MenuItem(this.mTitle, this.mPage);
  final String mTitle;
  final Widget mPage;

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: new ListTile(
            title: new Text(mTitle,
                style: new TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0)),
            onTap: () {
              gHomePage.fChangePage(mTitle, mPage);
            }));
  }
}

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key aKey}) : super(key: aKey);

  @override
  HomePage createState() => gHomePage;
}

class HomePage extends State<HomePageWidget> {
  bool mIsLogged = false;
  String mTitle;
  Widget mHomePageBody;
  NewsPageWidget mNewsPageWidget = new NewsPageWidget();
  MapPageWidget mMapPageWidget = new MapPageWidget();
  SchedulePageWidget mSchedulePageWidget = new SchedulePageWidget();
  ContactPageWidget mContactPageWidget = new ContactPageWidget();
  LinksPageWidget mLinksPageWidget = new LinksPageWidget();

  @override
  void initState() {
    print("HomePage:initState");
    super.initState();
    mTitle = "News";
    mHomePageBody = mNewsPageWidget;
  }

  @override
  void dispose() {
    print("HomePage:dispose");
    super.dispose();
    fCloseFirebaseData();
  }

  static Future<Null> fShowAlert(
      BuildContext context, String aTitle, String aBody) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(aTitle),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[new Text(aBody)],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext aContext) {
    print("HomePage:build:mIsLogged=" + mIsLogged.toString());
    if (mIsLogged) {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text(mTitle),
          ),
          drawer: new Drawer(
            child: new ListView(
              padding: new EdgeInsets.fromLTRB(15.0, 50.0, 50.0, 0.0),
              children: <Widget>[
                new MenuItem("News", mNewsPageWidget),
                new MenuItem("Map", mMapPageWidget),
                new MenuItem("Schedule", mSchedulePageWidget),
                new MenuItem("Contact", mContactPageWidget),
                new MenuItem("Links", mLinksPageWidget),
              ],
            ),
          ),
          body: mHomePageBody);
    } else {
      return new LoginPageWidget();
    }
  }

  void fChangePage(String aTitle, Widget aPage) {
    print("HomePage:fChangePage:aTitle=" + aTitle);
    mTitle = aTitle;
    mHomePageBody = aPage;
    gHomePage.setState(() {});
    Navigator.pop(context);
  }
}
