import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/testing_line/testing_line_device_controller.dart';

class TestingLineBottomBar extends StatelessWidget {
  const TestingLineBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TestingLineDeviceController>();

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
      decoration: BoxDecoration(
        // color: Colors.grey[50],  // 移除背景色
        // border: Border(top: BorderSide(color: Colors.grey[50]!)),
      ),
      child: Row(
        children: [
          Obx(() => FloatingActionButton(
                heroTag: 'call',
                onPressed: controller.isTLCallButtonEnabled.value
                    ? controller.triggerCall
                    : null,
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                child: const Icon(Icons.call),
              )),
          const SizedBox(width: 16),
          Obx(() => FloatingActionButton(
                heroTag: 'light',
                onPressed: controller.isTLLightButtonEnabled.value
                    ? controller.toggleLight
                    : null,
                backgroundColor: controller.isTLLightOn.value
                    ? Colors.amber[700]
                    : Colors.grey[300],
                foregroundColor: Colors.white,
                child: const Icon(Icons.lightbulb),
              )),
          const SizedBox(width: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(() => Row(
                children: [
                  Text(
                    '挂篮: ${controller.tlSliderValue.value.round()}%  ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                  Text(
                    '| 灯光: ${controller.isTLLightOn.value ? "开启" : "关闭"}  ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                  Text(
                    '| 温度: ${controller.temperature.value} °C  ', 
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                  Text(
                    '| 湿度: ${controller.humidity.value} %  ', 
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                  Text(
                    '| 光亮度: ${controller.lightLevel.value} Lux', 
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
} 