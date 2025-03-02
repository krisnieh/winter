import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/working_line/working_line_device_controller.dart';

class BottomControlBar extends StatelessWidget {
  const BottomControlBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkingLineDeviceController>();

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
                onPressed: controller.isWLCallButtonEnabled.value
                    ? controller.triggerCall
                    : null,
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                child: const Icon(Icons.call),
              )),
          const SizedBox(width: 16),
          Obx(() => FloatingActionButton(
                heroTag: 'light',
                onPressed: controller.isWLLightButtonEnabled.value
                    ? controller.toggleLight
                    : null,
                backgroundColor: controller.isWLLightOn.value
                    ? Colors.amber[700]
                    : Colors.grey[300],
                foregroundColor: Colors.white,
                child: const Icon(Icons.lightbulb),
              )),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'fan',
            onPressed: null,
            backgroundColor: Colors.grey[300],
            foregroundColor: Colors.grey[600],
            child: const Icon(Icons.air),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Obx(() => Row(
                children: [
                  Text(
                    '工作台: ${controller.wlSliderValue.value.round()}%  ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                  Text(
                    '| 灯光: ${controller.isWLLightOn.value ? "开启" : "关闭"}  ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                  Text(
                    '| 风扇: 未启用  ', 
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                  Text(
                    '| 温度: -', 
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                  Text(
                    '| 湿度: -  ', 
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    )
                  ),
                  Text(
                    '| 光亮: -', 
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