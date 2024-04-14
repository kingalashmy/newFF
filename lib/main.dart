// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:login_page/pages/homepage.dart';
import 'pages/ListStage.dart';
import 'pages/Missions.dart';
import 'pages/Objectifs.dart'; 
import 'pages/Realisations.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
        routes: {
        '/page1': (context) => HomePage(),
    // prefer_const_literals_to_create_immutables
        // ignore: prefer_const_literals_to_create_immutables
        '/page2': (context) => ListStage(userData: {},),
        '/page3': (context) => Missions(),
        '/page4': (context) => Objectifs(),
        '/page5': (context) => Realisations(),
       
      },
    );
  }
}
