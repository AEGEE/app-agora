import 'package:flutter/material.dart';
import 'pages/map/map_page.dart';
import 'pages/schedule/schedule_page.dart';
import 'pages/contact/contact_page.dart';
import 'pages/links/links_page.dart';
import 'pages/news/news_page.dart';
import 'utils/firebase_data.dart';
import 'utils/firebase_messaging.dart';
import 'utils/shared_preferences.dart';

HomePage gHomePage = new HomePage();

void main() async {
  await fInitSharedPreferences();
  fInitFirebaseMessaging();
  fInitFirebaseData();
  runApp(new AgoraApp());
}

class AgoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("AgoraApp started");
    return new MaterialApp(
        title: 'AEGEE Agora App',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new HomePageWidget());
  }
}

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

  @override
  Widget build(BuildContext aContext) {
    print("HomePage:build");
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
  }

  void fChangePage(String aTitle, Widget aPage) {
    print("HomePage:fChangePage:aTitle=" + aTitle);
    mTitle = aTitle;
    mHomePageBody = aPage;
    gHomePage.setState(() {});
    Navigator.pop(context);
  }
}
