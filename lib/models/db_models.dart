import 'dart:convert';
import 'dart:ui';
import 'package:charts_flutter/flutter.dart' as charts;

class Mood {
  int time;
  double mood;
  final Color barColor;

  Mood(this.time, this.mood, this.barColor);

  factory Mood.fromJson(dynamic json) {
    return Mood(json['time'] as int, json['mood'] as double, json['barColor'] as Color);
  }

  @override toString() {
    return '{ ${this.time}, ${this.mood}, ${this.barColor} }';
  }
}

class Entry {
  String date;
  List<Mood> moods;
  List symptoms;
  List food;
  List activity;
  List sleepQuality;

  Entry(
    this.date,
    this.moods,
    this.symptoms,
    this.food,
    this.activity,
    this.sleepQuality
  );

  factory Entry.fromJson(dynamic json) {
    return Entry(
        json['date'] as String,
        Mood.fromJson(json['moods']) as List<Mood>,
        json['symptoms'] as List,
        json['food'] as List,
        json['activity'] as List,
        json['sleepQuality'] as List
    );
  }

  @override
  String toString(){
    return '{ ${this.date}, ${this.moods}, ${this.symptoms}, ${this.food}. ${this.activity}, ${this.sleepQuality}}';
  }
}