// lib/pages/home.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../widgets/numeric_keypad.dart';
import '../widgets/vertical_slider.dart';
import '../widgets/vertical_icon_buttons.dart';

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
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('等待系统初始化...', style: TextStyle(fontSize: 24)),
                Text('System initializing...', style: TextStyle(color: Colors.grey),),
              ],
            ),
          ),
          Expanded(
            flex: 4,

            child: NumericKeypad(),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 500, // Set the desired height here
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
                VerticalIconButtons(
                  onLightPressed: () {
                    // Handle light button press
                    print('Light button pressed');
                  },
                  onFanPressed: () {
                    // Handle fan button press
                    print('Fan button pressed');
                  },
                  onPower12VPressed: () {
                    // Handle 12V power button press
                    print('12V power button pressed');
                  },
                  onPower24VPressed: () {
                    // Handle 24V power button press
                    print('24V power button pressed');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: FloatingActionButton(
          onPressed: controller.incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.handshake),
        ),
      ),
    );
  }
}