import 'dart:collection';
import 'dart:async';
import 'dart:core';
import "package:intl/date_symbols.dart";
import 'package:flutter/material.dart';
import '../../utils/firebase_data.dart';
import 'event_info.dart';
import 'day_events_list_view.dart';

class DayTab extends Tab {
  DayTab(this.mDateTime, aTitle) : super(text: aTitle);
  final DateTime mDateTime;
}

int fCompareDays(DateTime aLeftDateTime, DateTime aRightDateTime) {
  int diffInYears = aLeftDateTime.year - aRightDateTime.year;
  print("fCompareDays:diffInYears=$diffInYears");
  if (diffInYears > 0) {
    return 1;
  } else if (diffInYears < 0) {
    return -1;
  } else {
    int diffInMonths = aLeftDateTime.month - aRightDateTime.month;
    print("fCompareDays:diffInMonths=$diffInMonths");
    if (diffInMonths > 0) {
      return 1;
    } else if (diffInMonths < 0) {
      return -1;
    } else {
      int diffInDays = aLeftDateTime.day - aRightDateTime.day;
      print("fCompareDays:diffInDays=$diffInDays");
      if (diffInDays > 0) {
        return 1;
      } else if (diffInDays < 0) {
        return -1;
      } else {
        return 0;
      }
    }
  }
}

int fCompareDayTab(DayTab aLeftDayTab, DayTab aRightDayTab) {
  return fCompareDays(aLeftDayTab.mDateTime, aRightDayTab.mDateTime);
}

SplayTreeMap<DayTab, DayEventsListView> gEventListView =
    new SplayTreeMap<DayTab, DayEventsListView>(fCompareDayTab);

void fAddEventToList(aEventId, aEventInfo) {
  print("fAddEventToList");
  EventInfo eventInfo = new EventInfo(
      fGetDatabaseId(aEventId, 3),
      aEventInfo["title"],
      aEventInfo["body"],
      aEventInfo["place_id"],
      DateTime.parse(aEventInfo["start_time"]),
      DateTime.parse(aEventInfo["end_time"]));
  eventInfo.log();

  bool dayAlreadyInList = false;
  try {
    gEventListView.forEach((aDayTab, aDayEventsListView) {
      int result = fCompareDays(aDayTab.mDateTime, eventInfo.mStartTime);
      print("fAddEventToList:result=$result");
      if (result == 0) {
        dayAlreadyInList = true;
        aDayEventsListView.mEventInfoList.add(eventInfo);
        aDayEventsListView.mEventInfoList.sort(
            (firstEvent, secondEvent) => firstEvent.compareTo(secondEvent));
        throw new Exception("dayAlreadyInList");
      }
    });
  } on Exception {} /* only way to break forEach :P */

  print("fAddEventToList:dayAlreadyInList=" + dayAlreadyInList.toString());
  if (!dayAlreadyInList) {
    String weekday = eventInfo.mStartTime.day.toString() +
        " " +
        en_USSymbols.SHORTMONTHS[eventInfo.mStartTime.month - 1];
    DayTab dayTab = new DayTab(eventInfo.mStartTime, weekday);
    gEventListView[dayTab] = new DayEventsListView();
    gEventListView[dayTab].mEventInfoList.add(eventInfo);
  }
}

class SchedulePageWidget extends StatefulWidget {
  const SchedulePageWidget({Key aKey}) : super(key: aKey);
  @override
  SchedulePage createState() => new SchedulePage();
}

class SchedulePage extends State<SchedulePageWidget>
    with TickerProviderStateMixin {
  TabController mTabController;
  StreamSubscription<bool> mScheduleStreamSubscription;

  int fFindTodayDayTabIndex() {
    int index = 0;
    bool indexFound = false;
    try {
      gEventListView.forEach((aDayTab, aDayEventsListView) {
        int result = fCompareDays(aDayTab.mDateTime, DateTime.now());
        if (result == 0) {
          indexFound = true;
          throw new Exception("index");
        }
        index++;
      });
    } on Exception {}
    if (!indexFound) {
      index = 0;
    }
    print("fFindTodayDayTabIndex:index=$index");
    return index;
  }

  @override
  void initState() {
    print("SchedulePage:initState");
    super.initState();
    mScheduleStreamSubscription =
        gFirebaseData.mScheduleStream.listen((aNewsInfo) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    print("SchedulePage:dispose");
    super.dispose();
    if (mTabController != null) {
      mTabController.dispose();
    }
    mScheduleStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext aContext) {
    print(
        "SchedulePage:build:gDays.length=" + gEventListView.length.toString());

    if (gEventListView.length > 0) {
      int previousIndex = fFindTodayDayTabIndex();
      if (mTabController != null) {
        previousIndex = mTabController.index;
      }
      mTabController =
          new TabController(vsync: this, length: gEventListView.length + 1);
      mTabController.animateTo(previousIndex);
      TabBar dayTabBar = new TabBar(
        isScrollable: true,
        controller: mTabController,
        tabs: List.from(gEventListView.keys),
      );

      return new DefaultTabController(
        length: gEventListView.length + 1,
        child: new Scaffold(
          appBar: new AppBar(
            bottom: new PreferredSize(
              preferredSize: new Size(0.0, 0.0),
              child: new Container(child: dayTabBar),
            ),
          ),
          body: new TabBarView(
              controller: mTabController,
              children: List.from(gEventListView.values)),
        ),
      );
    } else {
      return new Center(child: new Text("No data..."));
    }
  }
}
