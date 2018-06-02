import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../../utils/firebase_data.dart';
import '../../utils/shared_preferences.dart';
import 'link_info.dart';

List<LinkInfo> gLinksList = new List<LinkInfo>();

void fGetLinksFromMemory() {
  String linksJson = gPrefs.getString(gLinksDatabaseKey);
  if (linksJson != null) {
    gLinksList.addAll(json.decode(linksJson).map<LinkInfo>((linkInfo) {
      return new LinkInfo(linkInfo['mId'], linkInfo['mName'], linkInfo['mUrl']);
    }).toList());
  }
}

void fAddLinkToList(aLinkId, aLinkInfo) {
  print("fAddLinkToList");
  LinkInfo linkInfo = new LinkInfo(
      fGetDatabaseId(aLinkId, 2), aLinkInfo["name"], aLinkInfo["url"]);
  linkInfo.log();
  gLinksList.add(linkInfo);
}

class LinksPageWidget extends StatefulWidget {
  const LinksPageWidget({Key aKey}) : super(key: aKey);
  @override
  LinksPage createState() => new LinksPage();
}

class LinksPage extends State<LinksPageWidget> {
  StreamSubscription<bool> mLinksStreamSubscription;

  @override
  void initState() {
    print("LinksPage:initState");
    super.initState();
    mLinksStreamSubscription =
        gFirebaseDataLinks.mStreamController.stream.listen((aLinkInfo) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    print("LinksPage:dispose");
    super.dispose();
    mLinksStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("LinksPage:build:gLinksList.length=" + gLinksList.length.toString());
    gLinksList.sort((firstLink, secondLink) {
      if (firstLink.mId > secondLink.mId) {
        return 1;
      } else {
        return -1;
      }
    });
    return new Scaffold(
        body: new ListView.builder(
            itemCount: gLinksList.length,
            padding: const EdgeInsets.all(6.0),
            itemBuilder: (context, index) {
              return new Card(
                child: new ListTile(
                  title: new Column(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(5.0)),
                      new Text(
                        gLinksList[index].mName,
                        style: new TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  onTap: () => launch(gLinksList[index].mUrl),
                ),
              );
            }));
  }
}
