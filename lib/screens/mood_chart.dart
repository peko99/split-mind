import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './doctor_display.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MoodChart extends StatelessWidget {
  final List<Mood> data;

  MoodChart({required this.data});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Mood, String>> series = [
      charts.Series(
        id: "Moods",
        data: data,
        domainFn: (Mood series, _) => series.time.toString(),
        measureFn: (Mood series, _) => series.mood,
        colorFn: (Mood series, _) => series.barColor,
      )
    ];
    return Column(
      children: <Widget> [
        Text ("Today moods chart"),
        Expanded(
          child: charts.BarChart(series, animate: true)
        )
      ],
    );
  }
}
