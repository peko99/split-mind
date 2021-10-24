import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import './mood_chart.dart';
import '../service/database.dart';
import './mood_counter.dart';

StreamController<List<Mood>> streamController = StreamController<List<Mood>>();

Map<dynamic, List<String>> mockEntry = {
  'symptoms': ['Headache']
};

const List<String> SYMPTOM_OPTIONS = [
  'Headache',
  'Depression',
  'Anxiety',
  'Exhaustion',
  'Migraine'
];
const List<String> FOOD_OPTIONS = [
  'Healty',
  'Unhealthy',
];
const List<String> SLEEP_QUALITY_OPTIONS = [
  'Insomnia',
  'Lack of sleep',
  'Good',
  'Irregular sleep',
];
const List<String> ACTIVITY_LEVEL_OPTIONS = [
  'High',
  'Medium',
  'Low',
  'Sedentary',
];

final _SYMPTOM_OPTIONS = SYMPTOM_OPTIONS
    .map((symptom) => MultiSelectItem<String?>(symptom, symptom))
    .toList();
final _FOOD_OPTIONS =
FOOD_OPTIONS.map((food) => MultiSelectItem<String?>(food, food)).toList();
final _SLEEP_QUALITY_OPTIONS = SLEEP_QUALITY_OPTIONS
    .map((sleep) => MultiSelectItem<String?>(sleep, sleep))
    .toList();
final _ACTIVITY_LEVEL_OPTIONS = ACTIVITY_LEVEL_OPTIONS
    .map((activity) => MultiSelectItem<String?>(activity, activity))
    .toList();

class Mood {
  int time;
  double mood;
  final charts.Color barColor;

  Mood({required this.time, required this.mood, required this.barColor});
}

List<Mood> sampleMoods = [
  Mood(
    time: DateTime.now().hour,
    mood: 5.5,
    barColor: charts.ColorUtil.fromDartColor(Colors.purple.withOpacity(0.35)),
  ),
  Mood(
    time: DateTime.now().add(Duration(hours: 3)).hour,
    mood: 7.5,
    barColor: charts.ColorUtil.fromDartColor(Colors.purple.withOpacity(0.35)),
  ),
  Mood(
    time: DateTime.now().add(Duration(hours: 4)).hour,
    mood: 6.5,
    barColor: charts.ColorUtil.fromDartColor(Colors.purple.withOpacity(0.35)),
  ),
];

class Entry {
  DateTime id;
  List<Mood> moods;

  Entry({required this.id, required this.moods});
}

Entry sampleEntry = Entry(id: DateTime.now(), moods: sampleMoods);

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
  final List<Mood> data = sampleEntry.moods;

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
          backgroundColor: Colors.deepPurple,
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
          actions: [
            Image.asset(
              'assets/konacna.png',
              height: 100.0,
              width: 100.0,

            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [
                MoodCounter(),
                Container(
                    width: double.infinity,
                    height: 250.0,
                    margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 15.0,
                            ),
                            child: MoodChart(data, streamController.stream),
                          ),
                        ),
                      ],
                    )),
                Container(
                    child: MultiSelectBottomSheetField(
                      items: _SYMPTOM_OPTIONS,
                      initialValue: mockEntry['symptoms'],
                      buttonText: Text('Symptoms'),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (symptoms) {
                        mockEntry['symptoms'] =
                            symptoms.map((symptom) => symptom.toString()).toList();
                        print(mockEntry['symptoms']);
                      },
                    )),
                Container(
                    child: MultiSelectBottomSheetField(
                      items: _FOOD_OPTIONS,
                      initialValue: mockEntry['symptoms'],
                      buttonText: Text('Food'),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (symptoms) {
                        mockEntry['symptoms'] =
                            symptoms.map((symptom) => symptom.toString()).toList();
                        print(mockEntry['symptoms']);
                      },
                    )),
                Container(
                    child: MultiSelectBottomSheetField(
                      items: _SLEEP_QUALITY_OPTIONS,
                      initialValue: mockEntry['symptoms'],
                      buttonText: Text('Sleep Quality'),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (symptoms) {
                        mockEntry['symptoms'] =
                            symptoms.map((symptom) => symptom.toString()).toList();
                        print(mockEntry['symptoms']);
                      },
                    )),
                Container(
                    child: MultiSelectBottomSheetField(
                      items: _ACTIVITY_LEVEL_OPTIONS,
                      initialValue: mockEntry['symptoms'],
                      buttonText: Text('Activity Level'),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (symptoms) {
                        mockEntry['symptoms'] =
                            symptoms.map((symptom) => symptom.toString()).toList();
                        print(mockEntry['symptoms']);
                      },
                    )),
              ],
            )));
  }
}