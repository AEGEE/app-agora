import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/firebase_data.dart';
import '../../utils/shared_preferences.dart';
import 'news_info.dart';

final List<NewsInfo> gNewsList = new List<NewsInfo>();

void fGetNewsFromMemory() {
  String newsJson = gPrefs.getString(gNewsDatabaseKey);
  if (newsJson != null) {
    gNewsList.addAll(json.decode(newsJson).map<NewsInfo>((newsInfo) {
      return new NewsInfo(
          newsInfo['mId'], newsInfo['mTitle'], newsInfo['mBody']);
    }).toList());
  }
}

void fAddNewsToList(aNewsId, aNewsInfo) {
  int newsId = fGetDatabaseId(aNewsId, 3);
  print("FirebaseData:fAddNewsToList");
  NewsInfo newsInfo =
      new NewsInfo(newsId, aNewsInfo["title"], aNewsInfo["body"]);
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
    gNewsList.sort((firstNews, secondNews) {
      if (firstNews.mId > secondNews.mId) {
        return 1;
      } else {
        return -1;
      }
    });
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
