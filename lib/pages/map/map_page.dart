import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/firebase_data.dart';
import '../../utils/shared_preferences.dart';
import 'map_place.dart';

final List<MapPlace> gPlacesList = new List<MapPlace>();

void fAddPlaceToList(aPlaceId, aPlaceInfo) {
  int placeId = fGetDatabaseId(aPlaceId, 2);
  print("fAddPlaceToMap:id=$placeId");
  MapPlace place = new MapPlace(placeId, aPlaceInfo['address'],
      aPlaceInfo['name'], aPlaceInfo['coord_x'], aPlaceInfo['coord_y']);
  place.log();
  gPlacesList.add(place);
}

MapPlace fGetPlaceById(int aId) {
  MapPlace mapPlace;
  gPlacesList.forEach((aMapPlace) {
    if (aMapPlace.mId == aId) {
      mapPlace = aMapPlace;
      return;
    }
  });
  return mapPlace;
}

class MapPageWidget extends StatefulWidget {
  const MapPageWidget({Key aKey}) : super(key: aKey);
  @override
  MapPage createState() => new MapPage();
}

class MapPage extends State<MapPageWidget> {
  StreamSubscription<bool> mPlacesStreamSubscription;

  static void fNavigateTo(double aCoordX, double aCoordY) async {
    print("fNavigateTo:aCoordX=$aCoordX,aCoordY=$aCoordY");
    String googleMapUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$aCoordX,$aCoordY&travelmode=walking";
    if (await canLaunch(googleMapUrl)) {
      await launch(googleMapUrl);
    } else {
      throw 'Could not launch Maps';
    }
  }

  @override
  void initState() {
    print("MapPage:initState");
    super.initState();
    mPlacesStreamSubscription = gFirebaseData.mNewsStream.listen((aNewsInfo) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    print("MapPage:dispose");
    super.dispose();
    mPlacesStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (gPlacesList.length == 0) {
      String newsJson = gPrefs.getString(gPlacesDatabaseKey);
      if (newsJson != null) {
        gPlacesList.addAll(json.decode(newsJson).map<MapPlace>((mapPlace) {
          return new MapPlace(mapPlace['mId'], mapPlace['mAddress'],
              mapPlace['mName'], mapPlace['mCoordX'], mapPlace['mCoordY']);
        }).toList());
      }
    }
    gPlacesList.sort((firstMapPlace, secondMapPlace) {
      if (firstMapPlace.mId > secondMapPlace.mId) {
        return 1;
      } else {
        return -1;
      }
    });
    print("MapPage:build:gPlacesList.values.length=" +
        gPlacesList.length.toString());
    return new Scaffold(
        body: new Column(
      children: <Widget>[
        new Padding(padding: EdgeInsets.all(10.0)),
        new Text(
          "Navigate me to:",
          style: new TextStyle(fontSize: 30.0),
        ),
        new Expanded(
          child: new ListView.builder(
              itemCount: gPlacesList.length,
              padding: const EdgeInsets.only(top: 10.0),
              itemExtent: 80.0,
              itemBuilder: (context, index) {
                return new Card(
                  child: new ListTile(
                    title: new Text(gPlacesList[index].mName),
                    subtitle: new Text(gPlacesList[index].mAddress),
                    onTap: () => fNavigateTo(
                        gPlacesList[index].mCoordX, gPlacesList[index].mCoordY),
                  ),
                );
              }),
        ),
      ],
    ));
  }
}