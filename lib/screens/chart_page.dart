import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/alarm_model.dart';

class ChartPage extends StatelessWidget {
  final List<AlarmModel> alarm;
  const ChartPage({
    super.key,
    required this.alarm,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chart Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          series: [
            BarSeries(
              dataSource: alarm,
              xValueMapper: (datum, index) => datum.hour,
              yValueMapper: (datum, index) => datum.minute,
            ),
          ],
        ),
      ),
    );
  }
}
