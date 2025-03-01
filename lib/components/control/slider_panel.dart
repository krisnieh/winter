import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SliderPanel extends StatelessWidget {
  final RxDouble sliderValue;
  final RxBool isSettingButtonEnabled;
  final VoidCallback onSetValue;

  const SliderPanel({
    super.key,
    required this.sliderValue,
    required this.isSettingButtonEnabled,
    required this.onSetValue,
  });

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
                    value: sliderValue.value,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: sliderValue.value.toStringAsFixed(0),
                    onChanged: (value) => sliderValue.value = value,
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
                    onPressed: isSettingButtonEnabled.value
                        ? onSetValue
                        : null,
                    child: Text(
                      sliderValue.value.toStringAsFixed(0),
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