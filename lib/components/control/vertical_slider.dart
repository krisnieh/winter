import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerticalSlider extends StatelessWidget {
  final RxDouble sliderValue;
  final RxBool isSettingButtonEnabled;
  final Function(double) onSetValue;

  const VerticalSlider({
    super.key,
    required this.sliderValue,
    required this.isSettingButtonEnabled,
    required this.onSetValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 滑块区域 (90%)
          Expanded(
            flex: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: Obx(() => Slider(
                    value: sliderValue.value,
                    onChanged: (value) {
                      onSetValue(value);
                      // 移除固定的数值显示位置，改为随动显示
                    },
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: sliderValue.value.toStringAsFixed(0), // 随动显示当前值
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 按钮区域 (10%)
          Expanded(
            flex: 10,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Obx(() => ElevatedButton(
                onPressed: isSettingButtonEnabled.value ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  sliderValue.value.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 24,  // 放大按钮字号
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
