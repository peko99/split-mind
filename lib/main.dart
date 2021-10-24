import 'package:flutter/material.dart';
import './screens/doctor_display.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './service/database.dart';

Future<void> main() async {
  runApp(const MyApp());

  // print('Calling inserttt');
  // insertEntry(entry);

  print('Reading from db');
  // getEntry('2021-10-24').then((value) => print(value));
  entry = await getEntry('2021-10-24');
  print(entry);
  // print('Updating entry');
  // updateEntry('2021-10-24', entryUpdated);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'split-mind',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: DoctorDisplay.id,
        routes: <String, Widget Function(BuildContext)>{
          LoginScreen.id: (BuildContext context) => LoginScreen(),
          HomeScreen.id: (BuildContext context) => HomeScreen(),
          DoctorDisplay.id: (BuildContext context) => DoctorDisplay(),
        });
  }
}
