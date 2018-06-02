import 'package:flutter/material.dart';
import 'pages/map/map_page.dart';
import 'pages/schedule/schedule_page.dart';
import 'pages/contact/contact_page.dart';
import 'pages/downloads_page.dart';
import 'pages/news/news_page.dart';
import 'utils/firebase_data.dart';
import 'utils/firebase_messaging.dart';
import 'utils/shared_preferences.dart';

HomePage gHomePage = new HomePage();

void main() async {
  await fInitSharedPreferences();
  fInitFirebaseMessaging();
  gFirebaseData.fSubscribe();
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

class MenuItem extends ListTile {
  MenuItem(String aTitle, Widget aPage)
      : super(
            title: new Text(aTitle),
            onTap: () {
              gHomePage.fChangePage(aTitle, aPage);
            });
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
  DownloadsPageWidget mDownloadsPageWidget = new DownloadsPageWidget();

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
    gFirebaseData.fUnsubscribe();
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
            padding: new EdgeInsets.fromLTRB(20.0, 40.0, 0.0, 0.0),
            children: <Widget>[
              new MenuItem("News", mNewsPageWidget),
              new Divider(),
              new MenuItem("Map", mMapPageWidget),
              new Divider(),
              new MenuItem("Schedule", mSchedulePageWidget),
              new Divider(),
              new MenuItem("Contact", mContactPageWidget),
              new Divider(),
              new MenuItem("Downloads", mDownloadsPageWidget),
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
