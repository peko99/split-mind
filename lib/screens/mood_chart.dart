import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './doctor_display.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';

class MoodChart extends StatefulWidget {
  List<Mood> data;
  final Stream<List<Mood>> stream;
  MoodChart(this.data, this.stream);


  List<Mood>? getData() {
    return this.data;
  }

  @override
  _MoodChartState createState() => _MoodChartState();
}

class _MoodChartState extends State<MoodChart> {
  @override
  void initState() {
    super.initState();
    widget.stream.listen((data2) {
      updateState(data2);
    });
  }

  void updateState(List<Mood> data2) {
    setState(() {
      widget.data = data2;
    });

  }

  @override
  Widget build(BuildContext context) {
    widget.data.sort((a, b) => a.time.compareTo(b.time));
    List<charts.Series<Mood, String>> series = [
      charts.Series(
        id: "Moods",
        data: widget.data,
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
