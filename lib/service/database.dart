import 'package:mongo_dart/mongo_dart.dart';

void insert(String date, String mood) async {
  final db = Db('mongodb://10.0.2.2/split_mind');

  await db.open();

  var collectionMoods = db.collection('moods');
  await collectionMoods.insertOne({'date': '$date', 'mood': '$mood'});

  print('success!!!');
  db.close();
}

void read() async {
  final db = Db('mongodb://10.0.2.2/split_mind');

  await db.open();

  var collectionMoods = db.collection('moods');
  var results = await collectionMoods.find().toList();

  db.close();
  print(results);
}

