import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/home/working_line_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HFS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.blue,
          inactiveTrackColor: Colors.blue.withAlpha(76),
          thumbColor: Colors.blue,
          overlayColor: Colors.blue.withAlpha(76),
          valueIndicatorColor: Colors.blue,
          valueIndicatorTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: const WorkingLinePage(),
    );
  }
}
