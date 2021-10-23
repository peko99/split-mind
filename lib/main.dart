import 'package:flutter/material.dart';
import './screens/doctor_display.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'split-mind',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomeScreen.id,
      routes: <String, Widget Function(BuildContext)>{
        LoginScreen.id: (BuildContext context) => LoginScreen(),
        HomeScreen.id: (BuildContext context) => HomeScreen(),
        DoctorDisplay.id: (BuildContext context) => DoctorDisplay(),
      }
    );
  }
}