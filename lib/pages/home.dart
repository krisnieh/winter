// lib/pages/home.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/vertical_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Row(
        children: <Widget>[
          const Expanded(
            flex: 7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Column 1, Text 1'),
                Text('Column 1, Text 2'),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: NumericKeypad(),
          ),
          Expanded(
            flex: 1,
            child: VerticalSlider(
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (double value) {
                // Handle value change
                print('Selected value: $value');
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}