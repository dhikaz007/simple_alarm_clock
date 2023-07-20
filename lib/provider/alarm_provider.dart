import 'package:flutter/material.dart';

import '../model/alarm_model.dart';

class AlarmProvider with ChangeNotifier {
  final List<AlarmModel> _alarm = [];
  int _hour = DateTime.now().hour;
  int _minute = DateTime.now().minute;

  List<AlarmModel> get alarm => _alarm;
  int get hour => _hour;
  int get minute => _minute;

  int changeHour(int hour) {
    _hour = hour ;
    notifyListeners();
    return _hour;
  }

  int changeMinute(int minute) {
    _minute = minute % 60;
    notifyListeners();
    return _minute;
  }
}
