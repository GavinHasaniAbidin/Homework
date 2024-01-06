import 'package:habitapp/screens/create_habit_screen.dart';
import 'package:habitapp/screens/onboarding_screen.dart';
import 'package:habitapp/screens/settings_screen.dart';
import 'package:habitapp/screens/statistics_screen.dart';
import 'package:flutter/material.dart';

Future navigateToSettingsPage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => SettingsScreen()));
}

Future navigateToStatisticsPage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => StatisticsScreen()));
}

Future navigateToCreatePage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => CreateHabitScreen()));
}

Future navigateToOnboarding(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => OnBoardingScreen()));
}

TimeOfDay parseTimeOfDay(String value) {
  if (value != null) {
    var times = value.split(":");
    if (times.length == 2)
      return TimeOfDay(hour: int.parse(times[0]), minute: int.parse(times[1]));
  }

  return TimeOfDay(hour: 12, minute: 0);
}

enum DayType { Clear, Check, Fail, Skip }

List<String> months = [
  "",
  "一月",
  "二月",
  "三月",
  "四月",
  "五月",
  "六月",
  "七月",
  "八月",
  "九月",
  "十月",
  "十一月",
  "十二月",
];

class HaboColors {
  static final Color primary = Color(0xFF09BF30);
  static final Color red = Colors.red;
  static final Color skip = Color(0xFF818181); //0xFF505050
  static final Color comment = Colors.yellow[700];
  static final Color orange = Colors.orange;
}
