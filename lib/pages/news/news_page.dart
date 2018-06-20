import 'dart:convert';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../utils/firebase_data.dart';
import '../../utils/shared_preferences.dart';
import '../login/login_page.dart';
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
  newsInfo.fLog();
  gNewsList.add(newsInfo);
}

class NewsPageWidget extends StatefulWidget {
  const NewsPageWidget({Key aKey}) : super(key: aKey);
  @override
  NewsPage createState() => new NewsPage();
}

class NewsPage extends State<NewsPageWidget> {
  StreamSubscription<bool> mNewsStreamSubscription;
  TextEditingController mNewsTitleTextEditingController =
      TextEditingController();
  TextEditingController mNewsBodyTextEditingController =
      TextEditingController();

  void fAddNews() {
    NewsInfo newsInfo = new NewsInfo(0, mNewsTitleTextEditingController.text,
        mNewsBodyTextEditingController.text);
    DatabaseReference reference = FirebaseDatabase.instance.reference().child(
        "news/news" + (gNewsList.last.mId + 1).toString().padLeft(3, '0'));
    reference.set(newsInfo.fToAdminNewsJson());
  }

  Future<Null> fAddNewsDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('Enter news details'),
            children: <Widget>[
              new SimpleDialogOption(
                child: new SizedBox(
                    width: 250.0,
                    height: 60.0,
                    child: new TextField(
                      controller: mNewsTitleTextEditingController,
                      decoration: new InputDecoration(
                        hintText: "Title",
                      ),
                    )),
              ),
              new SimpleDialogOption(
                child: new SizedBox(
                    width: 250.0,
                    height: 60.0,
                    child: new TextField(
                      controller: mNewsBodyTextEditingController,
                      decoration: new InputDecoration(
                        hintText: "Body",
                      ),
                    )),
              ),
              new FlatButton(
                child: new Text('Ok'),
                onPressed: () {
                  fAddNews();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    print("NewsPage:initState");
    super.initState();
    mNewsStreamSubscription =
        gFirebaseDataNews.mStreamController.stream.listen((aNewsInfo) {
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
    FloatingActionButton addNewNewsButton;
    if (gWhoAmI == AccountType.ADMIN) {
      addNewNewsButton = new FloatingActionButton(
          child: new Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: fAddNewsDialog);
    }
    return new Scaffold(
        body: new ListView.builder(
            itemCount: gNewsList.length,
            padding: const EdgeInsets.all(6.0),
            itemBuilder: (context, index) {
              return new Card(
                child: new ListTile(
                  title: new Text(gNewsList[index].mTitle,
                      style: new TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0)),
                  subtitle: new Text(gNewsList[index].mBody),
                ),
              );
            }),
        floatingActionButton: addNewNewsButton);
  }
}
