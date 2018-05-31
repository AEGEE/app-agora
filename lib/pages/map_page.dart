import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/firebase_data.dart';

class Place {
  Place(this.mAddress, this.mName, this.mCoordX, this.mCoordY);

  String mAddress;
  String mName;
  double mCoordX;
  double mCoordY;
  void log() {
    print("Place:" +
        "mAddress=" +
        mAddress +
        ",mName=" +
        mName +
        ",mCoordX=" +
        mCoordX.toString() +
        ",mCoordY=" +
        mCoordY.toString());
  }
}

void fAddPlaceToMap(aPlaceId, aPlaceInfo) async {
  int placeId = fGetDatabaseId(aPlaceId, 2);
  print("fAddPlaceToMap:id=$placeId");
  Place place = new Place(aPlaceInfo['address'], aPlaceInfo['name'],
      aPlaceInfo['coord_x'], aPlaceInfo['coord_y']);
  gPlacesMap[placeId] = place;
  place.log();
}

Map<int, Place> gPlacesMap = new Map<int, Place>();

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
    print("MapPage:build:gPlacesMap.values.length=" +
        gPlacesMap.values.length.toString());
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
              itemCount: gPlacesMap.values.length,
              padding: const EdgeInsets.only(top: 10.0),
              itemExtent: 80.0,
              itemBuilder: (context, index) {
                return new Card(
                  child: new ListTile(
                    title: new Text(gPlacesMap[index].mName),
                    subtitle: new Text(gPlacesMap[index].mAddress),
                    onTap: () => fNavigateTo(
                        gPlacesMap[index].mCoordX, gPlacesMap[index].mCoordY),
                  ),
                );
              }),
        ),
      ],
    ));
  }
}
