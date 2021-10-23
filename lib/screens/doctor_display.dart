import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import './mood_chart.dart';
import '../service/database.dart';

class Mood {
  int time;
  double mood;
  final charts.Color barColor;

  Mood({required this.time, required this.mood, required this.barColor});
}

class Entry {
  DateTime id;
  List<Mood> moods;

  Entry({required this.id, required this.moods});
}

// TODO: Put data in the db like in the function above


class DoctorDisplay extends StatefulWidget {
  static final String id = 'doctor';
  @override
  _DoctorDisplayState createState() => _DoctorDisplayState();
}

class _DoctorDisplayState extends State<DoctorDisplay> {
  // Date Variable
  DateTime _dateTime = DateTime.now();

  // Bar Chart
  final List<Mood> data = [
    Mood(
        time: DateTime.now().hour,
        mood: 5.5,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    Mood(
        time: DateTime.now().add(Duration(hours: 3)).hour,
        mood: 7.5,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    Mood(
        time: DateTime.now().add(Duration(hours: 4)).hour,
        mood: 6.5,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    )
  ];

  // TODO: Fetch data from db like in the upper function

  @override
  Widget build(BuildContext context) {
    String _formattedDate = new DateFormat.yMMMd().format(_dateTime);
    _openDatePicker(BuildContext context) async {
      final DateTime date = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1990),
        lastDate: DateTime(2030),
      ) as DateTime;

      setState(() {
        _dateTime = date;
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          _formattedDate,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: () => _openDatePicker(context),
        ),


      ),
      body:
      Container(
        width: double.infinity,
        height: 400.0,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 20.0
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.orange,
        ),
        child: Row(
          children: [
            Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 15.0,
                  ),
                  child: MoodChart(data: data,)
                ),
            ),
          ],
        )
      ),
    );
  }
}