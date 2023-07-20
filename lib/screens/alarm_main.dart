import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/alarm_provider.dart';
import 'alarm_page.dart';

class AlarmMain extends StatelessWidget {
  const AlarmMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AlarmProvider(),
      child: const AlarmPage(),
    );
  }
}
