import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import './doctor_display.dart';
import './mood_chart.dart';
import '../service/database.dart';
import '../models/db_models.dart';

class MoodCounter extends StatefulWidget {
  @override
  _MoodCounterState createState() => _MoodCounterState();
}

class _MoodCounterState extends State<MoodCounter> {
  double count = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.deepPurpleAccent,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 5.0),
            child: Text(
              'How are you feeling?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 25,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurpleAccent,
                  child: Icon(Icons.remove),
                  onPressed: () {
                    if (count < 0.5) return;
                    setState(() {
                      count -= 0.5;
                    });
                  },
                ),
                Text(
                  '$count',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 35,
                  ),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.deepPurpleAccent,
                  child: Icon(Icons.add),
                  onPressed: () {
                    if (count > 9.5) return;
                    setState(() {
                      count += 0.5;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor:
                    MaterialStateProperty.all(Colors.deepPurpleAccent),
              ),
              child: Text('Save'),
              onPressed: () {
                var mood = Mood(
                  time: DateTime.now().hour,
                  mood: count,
                  barColor: charts.ColorUtil.fromDartColor(Colors.blue),
                );
                sampleEntry.moods.add(mood);
                streamController.add(sampleEntry.moods);
              },
            ),
          ),
        ],
      ),
    );
  }
}
