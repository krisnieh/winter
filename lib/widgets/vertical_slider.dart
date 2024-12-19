// lib/widgets/vertical_slider.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/slider_controller.dart';

class VerticalSlider extends StatelessWidget {
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  const VerticalSlider({
    Key? key,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SliderController controller = Get.put(SliderController());

    return Obx(() => RotatedBox(
      quarterTurns: 3,
      child: Slider(
        value: controller.currentValue.value,
        min: min,
        max: max,
        divisions: divisions,
        label: controller.currentValue.value.round().toString(),
        onChanged: (double value) {
          controller.updateValue(value);
          onChanged(value);
        },
      ),
    ));
  }
}