import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/main_controller.dart';

class SliderPanel extends StatelessWidget {
  final MainController controller;

  const SliderPanel({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: Obx(() => Slider(
                    value: controller.sliderValue.value,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: controller.sliderValue.value.round().toString(),
                    onChanged: (value) => controller.sliderValue.value = value,
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Obx(() => SizedBox(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: controller.isSettingButtonEnabled.value
                        ? controller.setSliderValue
                        : null,
                    child: Text(
                      controller.sliderValue.value.round().toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
