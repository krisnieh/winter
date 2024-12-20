// lib/controllers/numeric_keypad_controller.dart
import 'package:get/get.dart';

class NumericKeypadController extends GetxController {
  var input = '80'.obs;

  void addInput(String value) {
    input.value += value;
  }

  void deleteInput() {
    if (input.value.isNotEmpty) {
      input.value = input.value.substring(0, input.value.length - 1);
    }
  }

  void confirmInput() {
    // Handle the confirmation logic here
    print('Confirmed input: ${input.value}');
  }
}