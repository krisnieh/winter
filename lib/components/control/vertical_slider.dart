import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/working_line/working_line_device_controller.dart';

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

  void _handleButtonPress() async {
    isSettingButtonEnabled.value = false;  // 禁用按钮
    try {
      final value = sliderValue.value.toStringAsFixed(0);
      await Get.find<WorkingLineDeviceController>().setPosition(value);
    } catch (e) {
      Get.snackbar(
        '错误',
        '设置失败: ${e.toString()}',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      isSettingButtonEnabled.value = true;  // 恢复按钮
    }
  }

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
                    onChanged: onSetValue,
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
                onPressed: isSettingButtonEnabled.value ? _handleButtonPress : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4), // 减小水平内边距
                  minimumSize: const Size.fromHeight(48), // 设置固定高度
                  elevation: 4, // 添加阴影
                  shadowColor: Colors.black.withOpacity(0.3), // 设置阴影颜色和透明度
                ),
                child: Text(
                  sliderValue.value.toStringAsFixed(0),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1, // 强制单行显示
                  overflow: TextOverflow.visible, // 允许文本溢出
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
