import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfo {
  ContactInfo(this.mId, this.mName, this.mDescription, this.mPhoneNumber);

  int mId;
  String mName;
  String mDescription;
  String mPhoneNumber;

  void log() {
    print(
        "ContactInfo:mId=$mId,mName=$mName,mDescription=$mDescription,mPhoneNumber=$mPhoneNumber");
  }
}

class ContactPageWidget extends StatefulWidget {
  const ContactPageWidget({Key aKey}) : super(key: aKey);
  @override
  ContactPage createState() => new ContactPage();
}

class ContactPage extends State<ContactPageWidget> {
  List<ContactInfo> mContactList = new List<ContactInfo>();
  StreamSubscription<Event> mContactSubscription;
  static DatabaseReference contactRef =
      FirebaseDatabase.instance.reference().child('contacts');

  void fAddContactToList(aContactId, aContactInfo) {
    print("fAddContactToList");
    String contactId = aContactId.toString();
    ContactInfo contactInfo = new ContactInfo(
        int.parse(contactId.substring(contactId.length - 2)),
        aContactInfo["name"],
        aContactInfo["description"],
        aContactInfo['phone_number']);
    contactInfo.log();
    mContactList.add(contactInfo);
  }

  @override
  void initState() {
    print("ContactPage:initState");
    super.initState();
    mContactSubscription = contactRef.onValue.listen((Event event) {
      setState(() {
        print("ContactPage:mContactSubscription:onValue");
        mContactList.clear();
        event.snapshot.value.forEach((fAddContactToList));
        mContactList.sort((a, b) {
          if (a.mId > b.mId) {
            return 1;
          } else if (a.mId == b.mId) {
            return 0;
          } else {
            return -1;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    print("ContactPage:dispose");
    super.dispose();
    mContactSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print("ContactPage:build");
    return new Scaffold(
        body: new ListView.builder(
            itemCount: mContactList.length,
            padding: const EdgeInsets.all(6.0),
            itemBuilder: (context, index) {
              return new Card(
                child: new ListTile(
                  leading: new Icon(Icons.person),
                  title: new Column(
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(5.0)),
                      new Text(
                        mContactList[index].mName,
                        style: new TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Padding(padding: EdgeInsets.all(5.0)),
                      new Text(
                        mContactList[index].mDescription,
                        style: new TextStyle(color: Colors.blueAccent),
                      ),
                      new Padding(padding: EdgeInsets.all(5.0)),
                      new Text(mContactList[index].mPhoneNumber),
                      new Padding(padding: EdgeInsets.all(5.0)),
                    ],
                  ),
                  trailing: new Icon(Icons.phone),
                  onTap: () =>
                      launch("tel://" + mContactList[index].mPhoneNumber),
                ),
              );
            }));
  }
}
