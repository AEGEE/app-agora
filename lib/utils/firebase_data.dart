import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'shared_preferences.dart';
import '../pages/contact/contact_page.dart';
import '../pages/map/map_page.dart';
import '../pages/schedule/day_events_info.dart';
import '../pages/news/news_page.dart';
import '../pages/schedule/schedule_page.dart';
import '../pages/links/links_page.dart';
import '../pages/login/login_page.dart';

const String gNewsDatabaseKey = "news";
const String gScheduleDatabaseKey = "schedule";
const String gPlacesDatabaseKey = "places";
const String gContactsDatabaseKey = "contacts";
const String gLinksDatabaseKey = "links";
const String gAdminDatabaseKey = "admins";

FirebaseData gFirebaseDataNews;
FirebaseData gFirebaseDataSchedule;
FirebaseData gFirebaseDataPlaces;
FirebaseData gFirebaseDataContacts;
FirebaseData gFirebaseDataLinks;
FirebaseData gFirebaseDataAdmins;

class FirebaseData {
  StreamController<bool> mStreamController;
  StreamSubscription<Event> mSubscription;
  DatabaseReference mRef;

  FirebaseData(String aDatabaseKey, dynamic aFunction) {
    mStreamController = new StreamController.broadcast();
    mRef = FirebaseDatabase.instance.reference().child(aDatabaseKey);
    mSubscription = mRef.onValue.listen((Event event) {
      print("FirebaseDataController:fSubscribe:listen:" + aDatabaseKey);
      dynamic globalVariable = fGetGlobalVariableByDatabaseKey(aDatabaseKey);
      globalVariable.clear();
      event.snapshot.value.forEach(aFunction);
      String globalVariableJson;
      if (aDatabaseKey != gScheduleDatabaseKey) {
        globalVariableJson = json.encode(globalVariable);
      } else {
        globalVariableJson = json
            .encode(fCreateDayEventsInfoListFromSplayTreeMap(gDayEventsMap));
      }
      gPrefs.setString(aDatabaseKey, globalVariableJson);
      mStreamController.add(true);
    });
  }

  dynamic fGetGlobalVariableByDatabaseKey(String aDatabaseKey) {
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
      case gLinksDatabaseKey:
        globalVariable = gLinksList;
        break;
      case gAdminDatabaseKey:
        globalVariable = gAdminsList;
        break;
    }
    return globalVariable;
  }

  void fClose() {
    mStreamController.close();
    mSubscription.cancel();
  }
}

int fGetDatabaseId(dynamic aDatabaseId, int aDecimalsNumber) {
  String databaseIdString = aDatabaseId.toString();
  return int.parse(
      databaseIdString.substring(databaseIdString.length - aDecimalsNumber));
}

void fInitFirebaseData() {
  gFirebaseDataNews = new FirebaseData(gNewsDatabaseKey, fAddNewsToList);
  gFirebaseDataSchedule =
      new FirebaseData(gScheduleDatabaseKey, fAddEventToList);
  gFirebaseDataPlaces = new FirebaseData(gPlacesDatabaseKey, fAddPlaceToList);
  gFirebaseDataContacts =
      new FirebaseData(gContactsDatabaseKey, fAddContactToList);
  gFirebaseDataLinks = new FirebaseData(gLinksDatabaseKey, fAddLinkToList);
  gFirebaseDataAdmins = new FirebaseData(gAdminDatabaseKey, fAddAdminToList);
}

void fCloseFirebaseData() {
  gFirebaseDataNews.fClose();
  gFirebaseDataSchedule.fClose();
  gFirebaseDataPlaces.fClose();
  gFirebaseDataContacts.fClose();
  gFirebaseDataLinks.fClose();
}
