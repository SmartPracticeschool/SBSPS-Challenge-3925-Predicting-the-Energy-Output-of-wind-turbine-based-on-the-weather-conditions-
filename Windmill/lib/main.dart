// Developed for Smart Internz IBM Hack Challenge 2020

// main.dart file is run by default by Flutter. All other files are then called from this file or are imported in this file

// import statement is used to import all the plugin and files which are used in this file.
import 'package:flutter/material.dart';
import 'screens/HomeScreen.dart';

void main() {
  // main() function is called by the compiler
  runApp(
      //runApp is the method called by main to start the execution of app
      MaterialApp(
    // Material app is the root widget of any Flutter app
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(), // Dark theme is used
    home: HomeScreen(),
  ));
}
