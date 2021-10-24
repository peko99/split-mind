import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:async';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import './mood_chart.dart';
import './mood_counter.dart';
import 'package:collection/collection.dart';

StreamController<List<Mood>> streamController = StreamController<List<Mood>>();
StreamController<Entry> entryStreamController = StreamController<Entry>();

List<Entry> entries = [];
Entry selectedEntry = instantiateDummyEntries();

List<String> getRandomElementsFromList(int number, List<String> source) => source.sample(number);

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
  'Healthy',
  'Unhealthy',
  'High carb',
  'High fat',
  'Keto',
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
  'Weight training',
  'Volume training',
  'Physiotherapy',
  'Sedentary',
];
const List<String> SUPPLEMENTS = [
  'Vitamin B',
  'Vitamin D',
  'Omega 3',
  'Creatine',
  'Protein Shake',
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
final _SUPPLEMENTS = SUPPLEMENTS
    .map((supplement) => MultiSelectItem<String?>(supplement, supplement))
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
  String id;
  List<Mood> moods;
  List<String> symptoms;
  List<String> foods;
  List<String> sleep_quality;
  List<String> activity;
  List<String> supplements;

  Entry({required this.id, required this.moods, required this.symptoms, required this.foods, required this.sleep_quality, required this.activity, required this.supplements});
}

Entry instantiateDummyEntries() {
  Random rng = Random();
  for (int i = 0; i < 10; i++) {
    String newDate = DateFormat('MMMM dd yyyy').format(DateTime.now().subtract(Duration(days: i)));
    List<Mood> newMoods = [];
    for (int i = 0; i < rng.nextInt(10); i++) {
      newMoods.add(Mood(time: rng.nextInt(24), mood: rng.nextInt(10).toDouble(), barColor: charts.ColorUtil.fromDartColor(Colors.purple.withOpacity(0.35))));
    }
    List<String> newSymptoms = getRandomElementsFromList(rng.nextInt(SYMPTOM_OPTIONS.length), SYMPTOM_OPTIONS);
    List<String> newFoods = getRandomElementsFromList(rng.nextInt(FOOD_OPTIONS.length), FOOD_OPTIONS);
    List<String> newSleepQuality = getRandomElementsFromList(rng.nextInt(SLEEP_QUALITY_OPTIONS.length), SLEEP_QUALITY_OPTIONS);
    List<String> newActivityLevel = getRandomElementsFromList(rng.nextInt(ACTIVITY_LEVEL_OPTIONS.length), ACTIVITY_LEVEL_OPTIONS);
    List<String> newSupplements = getRandomElementsFromList(rng.nextInt(SUPPLEMENTS.length), SUPPLEMENTS);
    entries.add(
      Entry(id: newDate, moods: newMoods, symptoms: newSymptoms, foods: newFoods, sleep_quality: newSleepQuality, activity: newActivityLevel, supplements: newSupplements)
    );
  }
  return entries[0];
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
        Entry newSelectedEntry = entries.firstWhere((element) => element.id == DateFormat('MMMM dd yyyy').format(_dateTime));
        selectedEntry = newSelectedEntry;
        entryStreamController.add(selectedEntry);
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
                          child: MoodChart(selectedEntry.moods, streamController.stream.asBroadcastStream()),
                      ),
                    ),
                  ],
                )),
            Container(
                child: MultiSelectBottomSheetField(
              items: _SYMPTOM_OPTIONS,
              initialValue: selectedEntry.symptoms,
              buttonText: Text('Symptoms'),
              listType: MultiSelectListType.CHIP,
              onConfirm: (symptoms) {
                selectedEntry.symptoms =
                    symptoms.map((symptom) => symptom.toString()).toList();;
              },
            )),
            Container(
                child: MultiSelectBottomSheetField(
              items: _FOOD_OPTIONS,
              initialValue: selectedEntry.foods,
              buttonText: Text('Food'),
              listType: MultiSelectListType.CHIP,
              onConfirm: (foods) {
                selectedEntry.foods =
                    foods.map((food) => food.toString()).toList();
              },
            )),
            Container(
                child: MultiSelectBottomSheetField(
              items: _SLEEP_QUALITY_OPTIONS,
              initialValue: selectedEntry.sleep_quality,
              buttonText: Text('Sleep Quality'),
              listType: MultiSelectListType.CHIP,
              onConfirm: (sleepQuality) {
                selectedEntry.sleep_quality =
                    sleepQuality.map((sleepQuality) => sleepQuality.toString()).toList();
              },
            )),
            Container(
                child: MultiSelectBottomSheetField(
              items: _ACTIVITY_LEVEL_OPTIONS,
              initialValue: selectedEntry.activity,
              buttonText: Text('Activity Level'),
              listType: MultiSelectListType.CHIP,
              onConfirm: (activityLevel) {
                selectedEntry.activity =
                    activityLevel.map((activityLevel) => activityLevel.toString()).toList();
              },
            )),
            Container(
                child: MultiSelectBottomSheetField(
                  items: _SUPPLEMENTS,
                  initialValue: selectedEntry.supplements,
                  buttonText: Text('Supplements'),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (supplements) {
                    selectedEntry.supplements =
                        supplements.map((symptom) => supplements.toString()).toList();
                  },
                )),
          ],
        )));
  }

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
