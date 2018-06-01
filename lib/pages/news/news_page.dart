import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/firebase_data.dart';
import '../../utils/shared_preferences.dart';
import 'news_info.dart';

final List<NewsInfo> gNewsList = new List<NewsInfo>();

void fAddNewsToList(aNewsId, aNewsInfo) {
  print("FirebaseData:fAddNewsToList");
  NewsInfo newsInfo = new NewsInfo(aNewsInfo["title"], aNewsInfo["body"]);
  newsInfo.log();
  gNewsList.add(newsInfo);
}

class NewsPageWidget extends StatefulWidget {
  const NewsPageWidget({Key aKey}) : super(key: aKey);
  @override
  NewsPage createState() => new NewsPage();
}

class NewsPage extends State<NewsPageWidget> {
  StreamSubscription<bool> mNewsStreamSubscription;

  @override
  void initState() {
    print("NewsPage:initState");
    super.initState();
    mNewsStreamSubscription = gFirebaseData.mNewsStream.listen((aNewsInfo) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    print("NewsPage:dispose");
    super.dispose();
    mNewsStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("NewsPage:build:gNewsList.length=" + gNewsList.length.toString());
    if (gNewsList.length == 0) {
      String newsJson = gPrefs.getString(gNewsDatabaseKey);
      if (newsJson != null) {
        gNewsList.addAll(json.decode(newsJson).map<NewsInfo>((newsInfo) {
          return new NewsInfo(newsInfo['mTitle'], newsInfo['mBody']);
        }).toList());
      }
    }
    return new Scaffold(
        body: new ListView.builder(
            itemCount: gNewsList.length,
            padding: const EdgeInsets.all(6.0),
            itemBuilder: (context, index) {
              return new Card(
                child: new ListTile(
                  title: new Text(gNewsList[index].mTitle,
                      style: new TextStyle(color: Colors.blue),
                      textAlign: TextAlign.center),
                  subtitle: new Text(gNewsList[index].mBody,
                      textAlign: TextAlign.center),
                ),
              );
            }));
  }
}
