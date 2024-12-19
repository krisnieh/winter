// lib/controllers/slider_controller.dart
import 'package:get/get.dart';

class SliderController extends GetxController {
  var currentValue = 50.0.obs;

  void updateValue(double value) {
    currentValue.value = value;
  }
}