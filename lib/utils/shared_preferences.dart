import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences gPrefs;

Future fInitSharedPreferences() async {
  gPrefs = await SharedPreferences.getInstance();
}
