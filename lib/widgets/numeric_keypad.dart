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
        Padding(
          padding: const EdgeInsets.all(16.0), // Set the desired margin
          child: Obx(() => Container(
            decoration: BoxDecoration(
              color: Colors.cyan[50],
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
            child: TextField(
              controller: TextEditingController(text: controller.input.value),
              style: const TextStyle(fontSize: 80),
              readOnly: true,
              textAlign: TextAlign.center, // Center the text
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
            ),
          )),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3,
            ),
            itemCount: keys.length,
            itemBuilder: (context, index) {
              ButtonStyle buttonStyle = ButtonStyles.numericKeypadButton;
              Widget buttonChild = Text(keys[index]);

              if (keys[index] == '←') {
                buttonStyle = ButtonStyles.deleteButton;
                buttonChild = const Icon(Icons.backspace, color: Colors.white);
              } else if (keys[index] == '✔') {
                buttonStyle = ButtonStyles.confirmButton;
                buttonChild = const Icon(Icons.check, color: Colors.white);
              }

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: 100,
                  height: 100,
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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: buttonChild,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}