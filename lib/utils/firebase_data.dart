import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../pages/contact/contact_page.dart';
import '../pages/map/map_page.dart';
import '../pages/schedule/day_events_info.dart';
import 'shared_preferences.dart';
import '../pages/news/news_page.dart';
import '../pages/schedule/schedule_page.dart';

const String gNewsDatabaseKey = "news";
const String gScheduleDatabaseKey = "schedule";
const String gPlacesDatabaseKey = "places";
const String gContactsDatabaseKey = "contacts";

int fGetDatabaseId(dynamic aDatabaseId, int aDecimalsNumber) {
  String databaseIdString = aDatabaseId.toString();
  return int.parse(
      databaseIdString.substring(databaseIdString.length - aDecimalsNumber));
}

class FirebaseData {
  /* News */
  StreamController<bool> mNewsStreamController =
      new StreamController.broadcast();
  StreamSubscription<Event> mNewsSubscription;
  DatabaseReference mNewsRef =
      FirebaseDatabase.instance.reference().child(gNewsDatabaseKey);
  Stream get mNewsStream => mNewsStreamController.stream;
  /* Schedule */
  StreamController<bool> mScheduleStreamController =
      new StreamController.broadcast();
  StreamSubscription<Event> mScheduleSubscription;
  DatabaseReference mScheduleRef =
      FirebaseDatabase.instance.reference().child(gScheduleDatabaseKey);
  Stream get mScheduleStream => mNewsStreamController.stream;
  /* Places */
  StreamController<bool> mPlacesStreamController =
      new StreamController.broadcast();
  StreamSubscription<Event> mPlacesSubscription;
  DatabaseReference mPlacesRef =
      FirebaseDatabase.instance.reference().child(gPlacesDatabaseKey);
  Stream get mPlacesStream => mPlacesStreamController.stream;
  /* Contacts */
  StreamController<bool> mContactsStreamController =
      new StreamController.broadcast();
  StreamSubscription<Event> mContactsSubscription;
  DatabaseReference mContactsRef =
      FirebaseDatabase.instance.reference().child(gContactsDatabaseKey);
  Stream get mContactsStream => mContactsStreamController.stream;

  dynamic fGetGlobalVariableBasedOnDatabaseKey(String aDatabaseKey) {
    dynamic globalVariable;
    switch (aDatabaseKey) {
      case gNewsDatabaseKey:
        globalVariable = gNewsList;
        break;
      case gScheduleDatabaseKey:
        globalVariable = gDayEventsMap;
        break;
      case gPlacesDatabaseKey:
        globalVariable = gPlacesList;
        break;
      case gContactsDatabaseKey:
        globalVariable = gContactsList;
        break;
    }
    return globalVariable;
  }

  void fSubscribeFor(
      StreamSubscription<Event> aSubscription,
      DatabaseReference aRef,
      dynamic aFunction,
      String aSharedKey,
      StreamController<bool> aStreamController) {
    print("FirebaseData:fSubscribe:" + aSharedKey);
    aSubscription = aRef.onValue.listen((Event event) {
      print("FirebaseData:fSubscribe:listen:" + aSharedKey);
      dynamic globalVariable = fGetGlobalVariableBasedOnDatabaseKey(aSharedKey);
      globalVariable.clear();
      event.snapshot.value.forEach(aFunction);
      String globalVariableJson;
      if (aSharedKey != gScheduleDatabaseKey) {
        globalVariableJson = json.encode(globalVariable);
      } else {
        globalVariableJson = json
            .encode(fCreateDayEventsInfoListFromSplayTreeMap(gDayEventsMap));
      }
      gPrefs.setString(aSharedKey, globalVariableJson);
      aStreamController.add(true);
    });
  }

  void fSubscribe() {
    fSubscribeFor(mNewsSubscription, mNewsRef, fAddNewsToList, gNewsDatabaseKey,
        mNewsStreamController);
    fSubscribeFor(mScheduleSubscription, mScheduleRef, fAddEventToList,
        gScheduleDatabaseKey, mScheduleStreamController);
    fSubscribeFor(mPlacesSubscription, mPlacesRef, fAddPlaceToList,
        gPlacesDatabaseKey, mPlacesStreamController);
    fSubscribeFor(mContactsSubscription, mContactsRef, fAddContactToList,
        gContactsDatabaseKey, mContactsStreamController);
  }

  void fUnsubscribe() {
    mNewsSubscription.cancel();
    mNewsStreamController.close();
    mScheduleSubscription.cancel();
    mScheduleStreamController.close();
    mPlacesSubscription.cancel();
    mPlacesStreamController.close();
    mContactsSubscription.cancel();
    mContactsStreamController.close();
  }
}

final FirebaseData gFirebaseData = new FirebaseData();
