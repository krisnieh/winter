// lib/widgets/numeric_keypad.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/numeric_keypad_controller.dart';
import '../styles/button_styles.dart';

class NumericKeypad extends StatelessWidget {
  final List<String> keys = [
    '1', '2', '3',
    '4', '5', '6',
    '7', '8', '9',
    '←', '0', '✔'
  ];

  @override
  Widget build(BuildContext context) {
    final NumericKeypadController controller = Get.put(NumericKeypadController());

    return Column(
      children: [
        Obx(() => Text(
          controller.input.value,
          style: const TextStyle(fontSize: 24),
        )),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3,
            ),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              ButtonStyle buttonStyle = ButtonStyles.numericKeypadButton;
              if (keys[index] == '←') {
                buttonStyle = ButtonStyles.deleteButton;
              } else if (keys[index] == '✔') {
                buttonStyle = ButtonStyles.confirmButton;
              }

              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    if (keys[index] == '←') {
                      controller.deleteInput();
                    } else if (keys[index] == '✔') {
                      controller.confirmInput();
                    } else {
                      controller.addInput(keys[index]);
                    }
                  },
                  child: Text(keys[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}