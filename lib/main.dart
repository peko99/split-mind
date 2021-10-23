import 'package:flutter/material.dart';
import 'package:split_mind/screens/doctor_display.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '@Protocol Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: DoctorDisplay.id,
      routes: <String, Widget Function(BuildContext)>{
        LoginScreen.id: (BuildContext context) => LoginScreen(),
        HomeScreen.id: (BuildContext context) => HomeScreen(),
        DoctorDisplay.id: (BuildContext context) => DoctorDisplay(),
      },
    );
  }
}
