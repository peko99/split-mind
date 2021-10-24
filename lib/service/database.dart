import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';
import '../models/db_models.dart';

void insertEntry(Entry objIn) async {
  final db = Db('mongodb://10.0.2.2/split_mind');
  await db.open();
  var entryCollection = db.collection('split_mind');

  await entryCollection.insertOne({
    'date': '${objIn.date}',
    'moods': '${objIn.moods}',
    'symptoms': '${objIn.symptoms}',
    'food': '${objIn.food}',
    'activity': '${objIn.activity}',
    'sleepQuality': '${objIn.sleepQuality}',
  });
}

Future<Entry> getEntry(String date) async {
  try {
  final db = Db('mongodb://10.0.2.2/split_mind');
  await db.open();
  var entryCollection = db.collection('split_mind');

  var response = await entryCollection.findOne(where.eq('date', '$date'));
  Entry entry = Entry.fromJson(jsonDecode(response.toString()));

  print(response);
  print('this is from inside the function');
  db.close();
  } catch (e) {
    print(e);
  } finally {
    return entry;
  }
}

void updateEntry(String date, Entry objIn) async {
  final db = Db('mongodb://10.0.2.2/split_mind');

  await db.open();
  var entryCollection = db.collection('split_mind');

  await entryCollection.deleteOne(where.eq(date, '$date'));
  insertEntry(objIn);

  print('Successfully updated mood');
  db.close();
}

void deleteCollection(String collection) async {
  final db = Db('mongodb://10.0.2.2/split_mind');

  await db.open();

  var collectionMoods = db.collection('$collection');
  collectionMoods.remove({});
  print('Deleted collection $collection');
  db.close();
}

Entry entry = Entry(
    '2021-10-24',
    [Mood(12, 5.5, Colors.blue)],
    ['shitty, tired'],
    ['unhealthy, fat'],
    ['decent'],
    ['poor']
);

Entry entryUpdated = Entry(
    '2021-07-29',
    [Mood(18, 9.5, Colors.green)],
    ['perfect'],
    ['perfect, healthy'],
    ['perfect'],
    ['perfect']
);