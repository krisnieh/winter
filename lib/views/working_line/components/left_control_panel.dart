import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/working_line/device_controller.dart';

class LeftControlPanel extends StatelessWidget {
  const LeftControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DeviceController>(); // 获取controller实例

    Future<void> showCallConfirmDialog() async {
      final result = await Get.dialog<bool>(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            '呼叫质量支持',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '所有呼叫将会记录在系统，并且可能用工作评估，是否确认继续？',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '取消',
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '确认',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.all(16),
        ),
      );

      if (result == true) {
        controller.triggerCall();
      }
    }

    return Positioned(
      left: 16,
      bottom: 16,
      child: Row(
        children: [
          Obx(() => FloatingActionButton(
                heroTag: 'call',
                onPressed: controller.isCallButtonEnabled.value
                    ? showCallConfirmDialog
                    : null,
                backgroundColor: Colors.red[600],
                foregroundColor: Colors.white,
                child: const Icon(Icons.call),
              )),
          const SizedBox(width: 16),
          Obx(() => FloatingActionButton(
                heroTag: 'light',
                onPressed: controller.isLightButtonEnabled.value
                    ? controller.toggleLight
                    : null,
                backgroundColor: controller.isLightOn.value
                    ? Colors.amber[700]
                    : Colors.grey[300],
                foregroundColor: Colors.white,
                child: const Icon(Icons.lightbulb),
              )),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'fan',
            onPressed: () {},
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            child: const Icon(Icons.air),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'load',
            onPressed: () {},
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.download),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'upload',
            onPressed: () {},
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.upload),
          ),
          const SizedBox(width: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(100),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Obx(() => Row(
              children: [
                Text(
                  '操作台: ${controller.sliderValue.value.round()}%  ',
                  style: const TextStyle(color: Colors.white)
                ),
                Text(
                  '灯光: ${controller.isLightOn.value ? "开启" : "关闭"}  ',
                  style: const TextStyle(color: Colors.white)
                ),
                const Text('风扇状态: -  ', style: TextStyle(color: Colors.white)),
                const Text('环境湿度: -  ', style: TextStyle(color: Colors.white)),
                const Text('环境温度: -', style: TextStyle(color: Colors.white)),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
