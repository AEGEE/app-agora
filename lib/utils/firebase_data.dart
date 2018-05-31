import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import '../pages/map_page.dart';
import 'shared_preferences.dart';
import '../pages/news/news_page.dart';
import '../pages/schedule/schedule_page.dart';

final String gNewsDatabaseKey = "news";
final String gScheduleDatabaseKey = "schedule";
final String gPlacesDatabaseKey = "places";

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

  void fSubscribeFor(
      StreamSubscription<Event> aSubscription,
      DatabaseReference aRef,
      dynamic aObject,
      dynamic aFunction,
      String aSharedKey,
      StreamController<bool> aStreamController) {
    print("FirebaseData:fSubscribe:" + aSharedKey);
    aSubscription = aRef.onValue.listen((Event event) {
      aObject.clear();
      event.snapshot.value.forEach((aFunction));
      try {
        gPrefs.setString(aSharedKey, json.encode(aObject));
      } catch (Exception) {} /* ToDo: Temporary workaround - remove when all objects will be JSON serializable */
      aStreamController.add(true);
    });
  }

  void fSubscribe() {
    fSubscribeFor(mNewsSubscription, mNewsRef, gNewsList, fAddNewsToList,
        gNewsDatabaseKey, mNewsStreamController);
    fSubscribeFor(mScheduleSubscription, mScheduleRef, gEventListView,
        fAddEventToList, gScheduleDatabaseKey, mScheduleStreamController);
    fSubscribeFor(mPlacesSubscription, mPlacesRef, gPlacesMap, fAddPlaceToMap,
        gPlacesDatabaseKey, mPlacesStreamController);
  }

  void fUnsubscribe() {
    mNewsSubscription.cancel();
    mNewsStreamController.close();
    mScheduleSubscription.cancel();
    mScheduleStreamController.close();
    mPlacesSubscription.cancel();
    mPlacesStreamController.close();
  }
}

final FirebaseData gFirebaseData = new FirebaseData();
